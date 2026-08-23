-- An in-process language server for qalc expressions.
--
-- There is no qalc language server and no tree-sitter grammar for qalc, so both
-- halves of "grammar-aware" are built here:
--
--   vocabulary   qalc's own tables (--list-units and friends). Which
--                identifiers are units rather than functions is data, not
--                syntax, so no grammar could have supplied it anyway.
--   context      a backward scan of the current line. Every buffer line is an
--                independent expression -- that is how qalc.nvim feeds them to
--                qalc -- so context never spans lines and the scan stays small.
--
-- Being a server rather than a bespoke completion source is what makes this
-- cheap: blink.cmp already lists `lsp` first in its sources and lsp.lua already
-- renders signature help, so both light up with no new plumbing.
-- See `:h lsp-server` for the in-process server contract.

local M = {}

-- LSP CompletionItemKind
local KIND = { unit = 11, func = 3, variable = 6, prefix = 14 }

-- {{{ talking to qalc

local function qalc(args, stdin)
    local res = vim.system(vim.list_extend({ 'qalc' }, args), { stdin = stdin, text = true }):wait()
    if res.code ~= 0 then return {} end
    return vim.split(res.stdout or '', '\n', { trimempty = false })
end

-- `help <name>` is only accepted as a command, not as an expression: `qalc -t
-- "help sin"` parses it as sin() times a help variable. Feeding it through
-- `-f -` is the non-interactive way in -- the same stdin form the plugin uses.
-- (`-f /dev/stdin` looks equivalent but qalc cannot open it from a pipe.)
local function qalc_help(name)
    return qalc({ '-f', '-' }, 'help ' .. name .. '\n')
end

-- }}}

-- {{{ vocabulary

-- Lines come back as tab-separated columns of `name / alias / alias`, so the
-- first name on each entry is the canonical one and the rest are aliases worth
-- completing in their own right.
local function parse_list(lines)
    local items = {}
    for _, line in ipairs(lines) do
        if line ~= '' and not line:match('^For more information') then
            for cell in vim.gsplit(line, '\t') do
                cell = vim.trim(cell)
                if cell ~= '' then
                    local canonical
                    for name in vim.gsplit(cell, '/') do
                        name = vim.trim(name)
                        if name ~= '' then
                            canonical = canonical or name
                            items[#items + 1] = { name = name, canonical = canonical }
                        end
                    end
                end
            end
        end
    end
    return items
end

local vocab = nil

local function load_vocab()
    if vocab then return vocab end
    vocab = {}
    for kind, flag in pairs({
        unit = '--list-units',
        func = '--list-functions',
        variable = '--list-variables',
        prefix = '--list-prefixes',
    }) do
        vocab[kind] = parse_list(qalc({ flag }))
    end
    return vocab
end

-- }}}

-- {{{ context: what is the cursor sitting after?

-- `to` and `->` convert. A bare `in` deliberately does not count: qalc itself
-- resolves it to inches, so `5 m in ft` is a volume rather than a conversion,
-- and suggesting units there would be suggesting the wrong thing confidently.
local function after_conversion(before)
    return before:match('%->%s*[%w_]*$') ~= nil
        or before:match('→%s*[%w_]*$') ~= nil
        or before:match('%f[%w]to%f[%W]%s*[%w_]*$') ~= nil
end

-- A number immediately to the left means implicit multiplication by a unit,
-- which is how `2 m` and `55 mph` are written.
local function after_number(before)
    return before:match('%d%s*[%a_]*$') ~= nil
end

-- Walks back to the innermost unclosed `(` and reports the call it belongs to,
-- plus which argument the cursor is in. Used for both completion ranking and
-- signature help.
local function enclosing_call(before)
    local depth = 0
    for i = #before, 1, -1 do
        local ch = before:sub(i, i)
        if ch == ')' then
            depth = depth + 1
        elseif ch == '(' then
            if depth == 0 then
                local name = before:sub(1, i - 1):match('([%a_][%w_]*)%s*$')
                if not name then return nil end
                local arg, d = 0, 0
                for j = i + 1, #before do
                    local c = before:sub(j, j)
                    if c == '(' then d = d + 1
                    elseif c == ')' then d = d - 1
                    elseif c == ',' and d == 0 then arg = arg + 1 end
                end
                return name, arg
            end
            depth = depth - 1
        end
    end
    return nil
end

-- Order the four kinds by how likely each is at this point in the line. The
-- first kind listed sorts to the top of the completion menu.
local function ranking(before)
    if after_conversion(before) then
        return { 'unit', 'prefix', 'variable', 'func' }
    end
    local fn = enclosing_call(before)
    if fn then
        return { 'variable', 'func', 'unit', 'prefix' }
    end
    if after_number(before) then
        return { 'unit', 'prefix', 'func', 'variable' }
    end
    return { 'func', 'variable', 'unit', 'prefix' }
end

-- }}}

-- {{{ parsing `help` output

-- Turns the help text into { kind, title, signature, params, docs } where
-- params are the positional arguments in order.
local function parse_help(lines)
    local info = { params = {}, docs = {} }

    for i, line in ipairs(lines) do
        local kind, title = line:match('^(%a+):%s*(.*)$')
        if kind and not info.kind then
            info.kind = kind
            info.title = vim.trim(title)
        end

        -- The signature is the first thing after the header carrying parens.
        -- It wraps at 80 columns, so keep appending until they balance.
        if not info.signature and info.kind and line:find('%(') then
            local sig = vim.trim(line)
            local j = i
            while select(2, sig:gsub('%(', '')) > select(2, sig:gsub('%)', '')) do
                j = j + 1
                if not lines[j] then break end
                sig = sig .. ' ' .. vim.trim(lines[j])
            end
            info.signature = sig

            local inner = sig:match('%((.*)%)$') or ''
            -- Optional arguments are written `[, Name]`; the brackets are not
            -- part of the name.
            for param in vim.gsplit(inner, ',') do
                param = vim.trim(param:gsub('[%[%]]', ''))
                if param ~= '' then info.params[#info.params + 1] = param end
            end
        end

        -- `Name: description` lines under the Arguments heading
        local pname, pdesc = line:match('^([%u][%w %-]-):%s+(.+)$')
        if pname and info.signature then info.docs[vim.trim(pname)] = vim.trim(pdesc) end
    end

    return info
end

-- }}}

-- {{{ the server

local function make_completion(before)
    local v = load_vocab()
    local items = {}
    for rank, kind in ipairs(ranking(before)) do
        for _, entry in ipairs(v[kind] or {}) do
            items[#items + 1] = {
                label = entry.name,
                kind = KIND[kind],
                -- The canonical name is the useful hint when completing a short
                -- alias: `m` on its own says nothing, `m -- meter` does.
                detail = entry.canonical ~= entry.name and entry.canonical or nil,
                sortText = ('%d%s'):format(rank, entry.name:lower()),
                data = { name = entry.canonical },
            }
        end
    end
    return items
end

local function make_signature(before)
    local fn, arg = enclosing_call(before)
    if not fn then return nil end

    local info = parse_help(qalc_help(fn))
    if not info.signature then return nil end

    local params = {}
    for _, p in ipairs(info.params) do
        params[#params + 1] = {
            label = p,
            documentation = info.docs[p],
        }
    end

    return {
        signatures = {
            {
                label = info.signature,
                documentation = info.title,
                parameters = params,
            },
        },
        activeSignature = 0,
        activeParameter = math.min(arg, math.max(#params - 1, 0)),
    }
end

local function help_markdown(name)
    local lines = qalc_help(name)
    local body = vim.trim(table.concat(lines, '\n'))
    if body == '' then return nil end
    return { kind = 'markdown', value = ('```\n%s\n```'):format(body) }
end

-- Reads the line under the request position straight out of the buffer, which
-- an in-process server can do instead of tracking didChange itself.
--
-- This resolves the buffer per request rather than capturing one, because
-- vim.lsp.start reuses a client across buffers whenever the config matches --
-- a captured bufnr would then answer for the wrong pad. It relies on the
-- buffer having a name: every unnamed buffer stringifies to "file://", which
-- vim.uri_to_bufnr turns back into a fresh empty buffer. calculator.lua names
-- the scratch pad for exactly this reason.
local function line_before(params)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local pos = params.position
    local line = vim.api.nvim_buf_get_lines(bufnr, pos.line, pos.line + 1, false)[1] or ''
    return line:sub(1, pos.character), line
end

local function cmd_fn(dispatchers)
    local closing = false
    local request_id = 0

    local srv = {}

    function srv.request(method, params, callback)
        if method == 'initialize' then
            callback(nil, {
                capabilities = {
                    completionProvider = {
                        -- Space matters: after `1 inch to ` there is no keyword
                        -- yet, and without a trigger nothing would be offered.
                        triggerCharacters = { ' ', '(', ',' },
                        resolveProvider = true,
                    },
                    signatureHelpProvider = { triggerCharacters = { '(', ',' } },
                    hoverProvider = true,
                },
                serverInfo = { name = 'qalc' },
            })
        elseif method == 'textDocument/completion' then
            local before = line_before(params)
            callback(nil, { isIncomplete = false, items = make_completion(before) })
        elseif method == 'completionItem/resolve' then
            -- Full help is only fetched for the item actually highlighted;
            -- doing it for all ~1300 entries up front would cost seconds.
            local item = vim.deepcopy(params)
            local name = item.data and item.data.name
            if name then item.documentation = help_markdown(name) end
            callback(nil, item)
        elseif method == 'textDocument/signatureHelp' then
            local before = line_before(params)
            callback(nil, make_signature(before))
        elseif method == 'textDocument/hover' then
            local _, line = line_before(params)
            local col = params.position.character
            -- widen from the cursor to the identifier under it
            local s, e = col, col
            while s > 0 and line:sub(s, s):match('[%w_]') do s = s - 1 end
            while e < #line and line:sub(e + 1, e + 1):match('[%w_]') do e = e + 1 end
            local word = line:sub(s + 1, e)
            callback(nil, word ~= '' and { contents = help_markdown(word) } or nil)
        elseif method == 'shutdown' then
            callback(nil, nil)
        else
            callback(nil, nil)
        end

        request_id = request_id + 1
        return true, request_id
    end

    function srv.notify(method, _)
        if method == 'exit' then dispatchers.on_exit(0, 15) end
        return true
    end

    function srv.is_closing() return closing end
    function srv.terminate() closing = true end

    return srv
end

-- }}}

function M.attach(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    return vim.lsp.start({
        name = 'qalc',
        cmd = cmd_fn,
        root_dir = nil,
    }, { bufnr = bufnr, attach = true })
end

return M

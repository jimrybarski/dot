-- Signature help: auto-trigger below cursor, always shows docs, single signature
-- Note: in Neovim 0.12, vim.lsp.buf.signature_help() uses buf_request_all directly
-- and bypasses vim.lsp.handlers entirely, so we must also use buf_request_all.
local sig_win = nil
local sig_ns = vim.api.nvim_create_namespace('user.lsp.signature_help')

local function trigger_signature_help()
    local bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    vim.lsp.buf_request_all(bufnr, 'textDocument/signatureHelp',
        function(client)
            return vim.lsp.util.make_position_params(win, client.offset_encoding)
        end,
        function(results, ctx)
            if not ctx or vim.api.nvim_get_current_buf() ~= ctx.bufnr then
                return
            end

            local client, sig = nil, nil
            for client_id, r in pairs(results) do
                if not r.err and r.result and r.result.signatures and #r.result.signatures > 0 then
                    client = vim.lsp.get_client_by_id(client_id)
                    local active_idx = (r.result.activeSignature or 0) + 1
                    local s = r.result.signatures[active_idx] or r.result.signatures[1]
                    s.activeParameter = s.activeParameter or r.result.activeParameter
                    sig = s
                    break
                end
            end

            if not sig then
                if sig_win and vim.api.nvim_win_is_valid(sig_win) then
                    vim.api.nvim_win_close(sig_win, true)
                    sig_win = nil
                end
                return
            end

            local ft = vim.bo[ctx.bufnr].filetype
            local triggers = vim.tbl_get(
                client.server_capabilities, 'signatureHelpProvider', 'triggerCharacters'
            )
            local lines, hl = vim.lsp.util.convert_signature_help_to_markdown_lines(
                { signatures = { sig } }, ft, triggers
            )
            if not lines then
                if sig_win and vim.api.nvim_win_is_valid(sig_win) then
                    vim.api.nvim_win_close(sig_win, true)
                    sig_win = nil
                end
                return
            end

            -- Reuse the existing window to update content in-place (prevents strobe).
            -- open_floating_preview always closes+recreates unless _update_win is set.
            local reuse = sig_win and vim.api.nvim_win_is_valid(sig_win) and sig_win or nil
            local float_bufnr, float_win = vim.lsp.util.open_floating_preview(lines, 'markdown', {
                border = 'rounded',
                anchor_bias = 'below',
                focusable = false,
                close_events = { 'CursorMoved', 'BufHidden', 'InsertLeave' },
                max_height = 10,
                max_width = 80,
                _update_win = reuse,
            })
            sig_win = float_win

            if hl then
                vim.api.nvim_buf_clear_namespace(float_bufnr, sig_ns, 0, -1)
                vim.hl.range(float_bufnr, sig_ns, 'LspSignatureActiveParameter',
                    { hl[1], hl[2] }, { hl[3], hl[4] })
            end
        end
    )
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method('textDocument/signatureHelp') then
            vim.api.nvim_create_autocmd('CursorMovedI', {
                buffer = args.buf,
                callback = trigger_signature_help,
            })
        end
    end,
})

-- Scroll signature help docs (blink.cmp uses the same keys with "fallback",
-- so these fire when the completion menu is closed)
vim.keymap.set('i', '<C-h>', function()
    if sig_win and vim.api.nvim_win_is_valid(sig_win) then
        vim.api.nvim_win_call(sig_win, function() vim.cmd('normal! 3k') end)
    end
end, { desc = 'Scroll signature help up' })

vim.keymap.set('i', '<C-l>', function()
    if sig_win and vim.api.nvim_win_is_valid(sig_win) then
        vim.api.nvim_win_call(sig_win, function() vim.cmd('normal! 3j') end)
    end
end, { desc = 'Scroll signature help down' })

-- LSP keymaps — buffer-local so they only fire in LSP-attached buffers
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buf = args.buf

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf, desc = 'LSP: go to definition' })
        vim.keymap.set('n', 'ge', vim.lsp.buf.declaration, { buffer = buf, desc = 'LSP: go to declaration' })
        vim.keymap.set('n', 'gD', function()
            -- Use Hop to jump to a character, then go to definition
            require('hop').hint_char1()
            vim.defer_fn(function()
                vim.lsp.buf.definition()
            end, 100)
        end, {})
        vim.keymap.set({'i', 'n'}, '<C-k>', vim.lsp.buf.hover, { buffer = buf, desc = 'LSP: hover' })
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, { buffer = buf, desc = 'LSP: rename' })
        vim.keymap.set('n', 'g[', function()
            vim.diagnostic.jump({ count = 1, float = false })
        end, { buffer = buf, desc = 'Go to next diagnostic' })
        vim.keymap.set('n', 'g]', function()
            vim.diagnostic.jump({ count = -1, float = false })
        end, { buffer = buf, desc = 'Go to previous diagnostic' })
        vim.keymap.set('n', 'gu', ':Telescope lsp_references<cr>', { buffer = buf, desc = 'LSP: show usages' })
        vim.keymap.set('n', 'gl', vim.lsp.buf.format, { buffer = buf, desc = 'LSP: format code' })
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { buffer = buf, desc = 'LSP: code action' })
        vim.keymap.set('n', 'gh', vim.diagnostic.open_float)

    end,
})

-- Enable inlay hints when a supporting LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})

-- Telescope (0.1.x) calls make_position_params without the encoding arg; shim it.
local _orig_position_params = vim.lsp.util.make_position_params
vim.lsp.util.make_position_params = function(window, encoding)
    window = window or vim.api.nvim_get_current_win()
    if not encoding then
        local bufnr = vim.api.nvim_win_get_buf(window)
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        encoding = clients[1] and clients[1].offset_encoding or "utf-16"
    end
    return _orig_position_params(window, encoding)
end

local pylspdir = vim.fn.expand("$HOME/.local/pylspenv/bin")
local basedpyright_command = string.format("%s/basedpyright-langserver", pylspdir)

-- Python type checking and intellisense — pip install basedpyright
vim.lsp.config("basedpyright", {
    cmd = { basedpyright_command, "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "standard",
            },
        },
    },
})

local ruff_command = string.format("%s/ruff", pylspdir)
-- Python formatting and linting — pip install ruff
vim.lsp.config("ruff", {
    cmd = { ruff_command, "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    on_init = function(client)
        client.offset_encoding = "utf-16"
    end,
})

-- Rust — rustup component add rust-analyzer
vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "Cargo.lock" },
})

-- Lua — brew install lua-language-server
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
        },
    },
})

-- Swift — sourcekit-lsp ships with the Swift toolchain / Xcode
vim.lsp.config("sourcekit", {
    cmd = { "sourcekit-lsp" },
    filetypes = { "swift", "objective-c", "objective-cpp" },
    root_markers = { "Package.swift", ".git" },
})

-- Fish — brew install fish-lsp
vim.lsp.config("fish_lsp", {
    cmd = { "fish-lsp", "start" },
    filetypes = { "fish" },
    root_markers = { ".git" },
})

-- Bash — npm install -g bash-language-server
vim.lsp.config("bash_ls", {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash" },
    root_markers = { ".git" },
})

-- Nextflow — https://github.com/nextflow-io/language-server
-- vim.lsp.config("nextflow_ls", {
--     cmd = { "java", "-jar", "/path/to/language-server-all.jar" },
--     filetypes = { "nextflow", "nf" },
--     root_markers = { "nextflow.config", ".git" },
-- })

-- For diagnostics with virtualtext, show the source of the diagnostic message
vim.diagnostic.config({
    virtual_text = true,
    float = true
})

vim.lsp.enable({ "basedpyright", "ruff", "rust_analyzer", "lua_ls", "sourcekit", "fish_lsp", "bash_ls" })

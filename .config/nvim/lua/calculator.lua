-- A floating scratch calculator, backed by qalc.nvim.
--
-- The plugin's own :Qalc opens a file-backed buffer in the current window, so
-- the buffer and the float are created here and its attach API is called
-- directly. Everything else (evaluation, virtual text, diagnostics) is still
-- the plugin's; see the spec in plugins.lua.

local M = {}

-- Both are kept across opens: closing the float only hides it, so reopening
-- brings back the previous calculations rather than an empty pad.
local bufnr = nil
local winid = nil

local function ensure_buf()
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
        return bufnr
    end
    -- unlisted + scratch, which already implies buftype=nofile and noswapfile
    bufnr = vim.api.nvim_create_buf(false, true)

    -- Named only so it has a stable URI: an unnamed buffer stringifies to a
    -- bare "file://", which the language server cannot resolve back to a
    -- buffer. Nothing is ever written here -- the buffer is still nofile.
    vim.api.nvim_buf_set_name(bufnr, vim.fn.stdpath('cache') .. '/calculator.qalc')

    -- Buffer-local so they only ever apply to this float. `nowait` because q
    -- would otherwise sit waiting for a register to record a macro into.
    for _, key in ipairs({ 'q', '<Esc>' }) do
        vim.keymap.set('n', key, M.close,
            { buffer = bufnr, nowait = true, desc = "Close calculator" })
    end

    return bufnr
end

-- qalc.nvim only places its results as 'eol' virtual text, which never wraps:
-- once an expression is long enough, the result runs past the right edge of the
-- float and is simply cut off. Inline virtual text does wrap, so each extmark
-- the plugin places is rewritten in place -- same id and same chunks, moved to
-- the end of the line and marked inline.
local function wrap_results(ns, bufnr)
    for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(bufnr, ns, 0, -1, { details = true })) do
        local id, row, details = mark[1], mark[2], mark[4]
        if details.virt_text and details.virt_text_pos == 'eol' then
            local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
            if line then
                -- 'eol' is given a leading space by the editor; inline is not
                local chunks = { { ' ', details.virt_text[1][2] } }
                vim.list_extend(chunks, details.virt_text)

                vim.api.nvim_buf_set_extmark(bufnr, ns, row, #line, {
                    id = id,
                    virt_text = chunks,
                    virt_text_pos = 'inline',
                    hl_mode = 'combine',
                })
            end
        end
    end
end

-- job.lua re-requires the display module on every update, so replacing the
-- field is enough to catch every redraw. Reaching into a plugin's internals is
-- worth flagging: if qalc.nvim ever changes how it displays results, this is
-- the part that silently stops applying (the results themselves keep working).
local patched = false

local function patch_display()
    if patched then return end
    patched = true

    local display = require('qalc.display')
    local update_all = display.update.all
    display.update.all = function(ns, bufnr, config, items)
        update_all(ns, bufnr, config, items)
        wrap_results(ns, bufnr)
    end
end

-- The pad opens ready to type. On a reopen that means the end of the last
-- existing line rather than the top, so the next expression continues the
-- session instead of landing in the middle of it.
local function start_typing()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })
    -- bang appends at end of line, the way A does
    vim.cmd('startinsert!')
end

function M.open()
    -- Already open: focus it instead of stacking a second float on top
    if winid and vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_set_current_win(winid)
        start_typing()
        return
    end

    local buf = ensure_buf()

    -- Wide enough that a result in virtual text still fits after the
    -- expression, and clamped so a small terminal can't overflow the screen.
    local width = math.min(72, math.max(40, math.floor(vim.o.columns * 0.6)), vim.o.columns - 4)
    local height = math.min(16, math.max(8, math.floor(vim.o.lines * 0.4)), vim.o.lines - 4)

    winid = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2) - 1,
        col = math.floor((vim.o.columns - width) / 2),
        -- border comes from the global 'winborder', as elsewhere in the config
        style = 'minimal',
        title = ' Calculator   q/esc close ',
        title_pos = 'center',
    })

    -- style=minimal turns the sign column off, and with virtual text already
    -- spoken for by the result, signs are the only thing marking a bad line.
    vim.wo[winid].signcolumn = 'yes:1'

    -- Load-bearing for wrap_results: a result only flows onto the next screen
    -- line if the window wraps at all. The indent keeps a continuation line
    -- from being mistaken for a new expression.
    vim.wo[winid].wrap = true
    vim.wo[winid].linebreak = true
    vim.wo[winid].breakindent = true
    vim.wo[winid].breakindentopt = 'shift:2'

    -- Both before attach, so the very first result is already wrapped
    patch_display()
    require('qalc').attach.current()

    -- Units and function signatures, served in-process; see lua/qalc_lsp.lua
    require('qalc_lsp').attach(buf)

    start_typing()
end

function M.close()
    if winid and vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_win_close(winid, false)
    end
    winid = nil
end

return M

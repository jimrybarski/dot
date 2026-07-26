-- Editing side of the agenda.
--
-- markdown-agenda.nvim only reads: it globs ~/notes for lines matching `- [ ]`
-- or `- [-]` that carry an @scheduled(...) or @deadline(...) annotation, and
-- never writes a byte back. So scheduling a task, giving it a deadline, or
-- checking it off is hand-editing. This module is that half.
--
--     - [ ] Buy tofu @scheduled(2026-07-30) @deadline(2026-08-05)
--
-- The same four actions work in a note and from inside the agenda window, where
-- they edit the underlying note and redraw.
--
-- Dates are day-granularity. The `%Y-%m-%d` format is fixed here to match
-- `date_format` in plugins.lua; changing one means changing the other.

local M = {}

-- Checkbox states the agenda understands: `- [ ]` todo and `- [-]` in progress.
-- `- [x]` is invisible to it, which is exactly what "done" ought to mean -- a
-- finished task drops out of the view without the line going anywhere.
local function checkbox_state(line)
    return line:match("^%s*%- %[(.)%]")
end

local function set_state(line, state)
    return (line:gsub("^(%s*%- %[).(%])", "%1" .. state .. "%2", 1))
end

-- Prose becomes an unchecked task, reusing a bullet if the line already has one.
local function to_task(line)
    local indent, rest = line:match("^(%s*)(.*)$")
    return indent .. "- [ ] " .. rest:gsub("^[-*+]%s+", "")
end

local function annotations(line)
    return line:match("@scheduled%((.-)%)"), line:match("@deadline%((.-)%)")
end

-- Rewrite both annotations at once, always emitting @scheduled before @deadline.
-- The plugin matches them independently, so the order is purely for the reader;
-- normalising it stops repeated edits from shuffling them around the line.
local function set_annotations(line, scheduled, deadline)
    local indent = line:match("^%s*")
    local text = line:gsub("%s*@scheduled%([^)]*%)", ""):gsub("%s*@deadline%([^)]*%)", "")
    text = indent .. vim.trim(text)

    if scheduled then text = text .. " @scheduled(" .. scheduled .. ")" end
    if deadline then text = text .. " @deadline(" .. deadline .. ")" end
    return text
end

local weekday_names = {
    "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday",
}

-- Date arithmetic through os.time's normalisation rather than by adding seconds:
-- a day is not always 86400 seconds, and anchoring at noon keeps a DST shift from
-- landing on the neighbouring date. Overlong months normalise the way mktime
-- does, so Jan 31 +1m is Mar 3, not Feb 28.
local function shift(days, months)
    local now = os.date("*t")
    return os.date("%Y-%m-%d", os.time({
        year = now.year,
        month = now.month + (months or 0),
        day = now.day + (days or 0),
        hour = 12,
    }))
end

-- Shorthand -> YYYY-MM-DD, or nil if it means nothing. Accepts a literal date,
-- `today`/`tomorrow`, an offset like `+3d` / `2w` / `+1m`, or a weekday name of
-- at least three letters. A weekday always means the *next* one, so typing `fri`
-- on a Friday is a week out -- the alternative would silently schedule something
-- for a day already half gone.
local function resolve(input)
    input = vim.trim(input):lower()

    if input:match("^%d%d%d%d%-%d%d%-%d%d$") then return input end
    if input == "today" or input == "tod" then return shift(0) end
    if input == "tomorrow" or input == "tom" then return shift(1) end

    local count, unit = input:match("^%+?(%d+)([dwm]?)$")
    if count then
        count = tonumber(count)
        if unit == "w" then return shift(count * 7) end
        if unit == "m" then return shift(0, count) end
        return shift(count)
    end

    if #input >= 3 then
        for index, name in ipairs(weekday_names) do
            if name:sub(1, #input) == input then
                local delta = (index - os.date("*t").wday) % 7
                return shift(delta == 0 and 7 or delta)
            end
        end
    end
end

-- An action is `f(line, done)`, calling done(new_line) or done(nil) to cancel.
-- The callback shape is what lets the date prompts, which are asynchronous, sit
-- alongside the instant toggles and drive both front-ends unchanged.
local function date_action(field)
    return function(line, done)
        local scheduled, deadline = annotations(line)
        local current
        if field == "scheduled" then current = scheduled else current = deadline end

        vim.ui.input({ prompt = field .. ": ", default = current or "" }, function(input)
            -- Aborting the prompt is nil; submitting it empty clears the field,
            -- which is what deleting the prefilled date looks like.
            if not input then return done(nil) end

            local date
            if vim.trim(input) ~= "" then
                date = resolve(input)
                if not date then
                    vim.notify(string.format("Not a date: %q", input), vim.log.levels.WARN)
                    return done(nil)
                end
            end

            -- Branching rather than `field == "x" and date or scheduled`: that
            -- idiom takes the wrong arm the moment the value is nil, which is
            -- precisely the case that clears a date.
            if field == "scheduled" then scheduled = date else deadline = date end
            done(set_annotations(line, scheduled, deadline))
        end)
    end
end

local actions = {
    done = function(line, done)
        done(set_state(line, checkbox_state(line) == "x" and " " or "x"))
    end,
    progress = function(line, done)
        done(set_state(line, checkbox_state(line) == "-" and " " or "-"))
    end,
    scheduled = date_action("scheduled"),
    deadline = date_action("deadline"),
}

-- Apply an action to line `lnum` of `buf`.
--
-- The line is re-read inside the callback because the date prompts hand control
-- back to the user: the cursor can be anywhere, and the buffer can have changed,
-- by the time an answer arrives.
local function apply(buf, lnum, kind, after)
    local function line_at()
        return (vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false))[1]
    end

    local before = line_at()
    if not before then return end

    actions[kind](before, function(new)
        if not new then return end
        if line_at() ~= before then
            vim.notify("Line changed while the prompt was open", vim.log.levels.WARN)
            return
        end

        vim.api.nvim_buf_set_lines(buf, lnum - 1, lnum, false, { new })
        if after then after() end
    end)
end

-- Act on the task under the cursor in a note.
function M.here(kind)
    local buf = vim.api.nvim_get_current_buf()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_get_current_line()

    if not checkbox_state(line) then
        if vim.trim(line) == "" then
            vim.notify("Not a task", vim.log.levels.WARN)
            return
        end

        -- A line you are scheduling is a task by definition, so promote it. That
        -- also makes <localleader>x on plain prose the quickest way to start one,
        -- and stopping there is the point: it would be a fresh `- [ ]`, and
        -- immediately marking it done is never what the keystroke meant.
        vim.api.nvim_set_current_line(to_task(line))
        if kind == "done" or kind == "progress" then return end
    end

    apply(buf, lnum, kind)
end

-- The agenda's line -> task table is a local inside markdown-agenda's open(),
-- exported nowhere. Its <CR> handler closes over it, so the closure is the only
-- handle on it that exists. Reading the upvalue out by name is exact -- it is the
-- same table the plugin resolves <CR> against, duplicates and all -- but it ties
-- this to the plugin's internals, so a rename upstream has to degrade loudly
-- rather than silently act on whatever line the cursor happens to sit on.
local function task_at(buf, lnum)
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
        if map.callback and (map.lhs == "<CR>" or map.lhs == vim.keycode("<CR>")) then
            local index = 1
            while true do
                local name, value = debug.getupvalue(map.callback, index)
                if not name then break end
                if name == "current_task_map" and type(value) == "table" then
                    return value[lnum], true
                end
                index = index + 1
            end
        end
    end
    return nil, false
end

-- Redraw by reopening: refresh_agenda() is local too, and open() rescans from
-- disk, which is where the edit just landed. Fold state lives in the plugin's
-- module table, so it survives the round trip; the cursor doesn't, and the view
-- can be shorter now that a task has dropped out of it.
local function reopen(win, lnum)
    if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
    end

    require("markdown-agenda").open()

    local new_win = vim.api.nvim_get_current_win()
    local count = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(new_win))
    vim.api.nvim_win_set_cursor(new_win, { math.min(lnum, count), 0 })
end

-- Act on the task under the cursor in the agenda window, editing the note it
-- came from.
function M.from_agenda(kind)
    local win = vim.api.nvim_get_current_win()
    local lnum = vim.api.nvim_win_get_cursor(win)[1]
    local task, resolved = task_at(vim.api.nvim_get_current_buf(), lnum)

    if not resolved then
        vim.notify("Can't reach the agenda's task list; markdown-agenda has changed",
            vim.log.levels.ERROR)
        return
    end
    if not task then return end

    -- The agenda scanned the file on disk, so its line numbers describe the disk
    -- contents. Acting on a buffer with unsaved edits would apply them to a line
    -- that has since moved.
    local note = vim.fn.bufadd(task.filepath)
    vim.fn.bufload(note)
    if vim.bo[note].modified then
        vim.notify(vim.fs.basename(task.filepath) .. " has unsaved changes", vim.log.levels.WARN)
        return
    end

    local line = (vim.api.nvim_buf_get_lines(note, task.line - 1, task.line, false))[1]
    if not line or not checkbox_state(line) then
        vim.notify("No task on that line any more; reopen the agenda", vim.log.levels.WARN)
        return
    end

    apply(note, task.line, kind, function()
        vim.api.nvim_buf_call(note, function() vim.cmd("silent write") end)
        reopen(win, lnum)
    end)
end

return M

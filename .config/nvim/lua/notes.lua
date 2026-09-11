-- Timestamped notes in ~/notes/<year>/, e.g. ~/notes/2026/20260725-193045.md
--
-- Every note carries YAML frontmatter:
--
--     ---
--     title: Comedians I like
--     alias: comedians          <- optional; only bookmarked notes have one
--     tags: [ comedy, lists ]
--     ---
--
-- Telekasten handles search, tags, [[links]] and backlinks. This module covers
-- what it can't: creating notes into year directories, walking the timeline,
-- daily notes, and browsing by frontmatter (filenames are timestamps, so every
-- filename-based picker is useless here).

local M = {}

local root = vim.fn.expand("~/notes")

-- Only four-digit year directories hold notes. Matching them explicitly keeps
-- img/ and any future non-note directory out of the timeline.
local note_glob = root .. "/[0-9][0-9][0-9][0-9]/*.md"

-- Every note, oldest first. Filenames are zero-padded timestamps, so sorting
-- the basenames lexicographically is exact chronological order, and notes in
-- different year directories interleave correctly without special handling.
local function all_notes()
    local files = vim.fn.glob(note_glob, false, true)
    table.sort(files, function(a, b) return vim.fs.basename(a) < vim.fs.basename(b) end)
    return files
end

local function open(path)
    vim.cmd.edit(vim.fn.fnameescape(path))
end

-- Write a note into this year's directory and drop the cursor into the body.
--
-- Every note is born here, which is the only reason the cache drop can be a
-- single line: notes are written straight to disk rather than through a buffer,
-- so the BufWritePost hook that normally invalidates it (autocommands.lua) never
-- sees them. Miss the drop and a [[link]] to a note created this session renders
-- as a bare timestamp until some unrelated write happens to rebuild the map.
local function create(title, tags)
    local dir = string.format("%s/%s", root, os.date("%Y"))
    vim.fn.mkdir(dir, "p")
    local path = string.format("%s/%s.md", dir, os.date("%Y%m%d-%H%M%S"))

    vim.fn.writefile({
        "---",
        "title: " .. title,
        "tags: [" .. table.concat(tags, ", ") .. "]",
        "---",
        "",
        "",
    }, path)

    M.invalidate()
    open(path)
    vim.cmd("normal! G")
end

function M.new()
    vim.ui.input({ prompt = "Note title: " }, function(title)
        if not title or title == "" then return end
        create(title, {})
    end)
end

-- Move `delta` entries along `files`, oldest first, starting from whatever is in
-- the current buffer. `label` is the singular noun for the messages at the ends
-- of the list. A buffer that isn't in `files` at all -- a scratch buffer, or an
-- ordinary note when walking the dailies -- starts at the newest entry, which is
-- the only useful answer when there's no position to move from.
local function step_through(files, delta, label)
    if #files == 0 then
        vim.notify("No " .. label .. "s yet", vim.log.levels.INFO)
        return
    end

    local current = vim.fn.expand("%:p")
    local index
    for i, path in ipairs(files) do
        if path == current then
            index = i
            break
        end
    end

    if not index then
        open(files[#files])
        return
    end

    local target = index + delta
    if target < 1 then
        vim.notify("Oldest " .. label, vim.log.levels.INFO)
    elseif target > #files then
        vim.notify("Newest " .. label, vim.log.levels.INFO)
    else
        open(files[target])
    end
end

function M.older() step_through(all_notes(), -1, "note") end

function M.newer() step_through(all_notes(), 1, "note") end

-- Collect one frontmatter field across the whole vault, newest note first.
local function scan(field)
    local output = vim.fn.systemlist({
        "rg", "--no-heading", "--with-filename", "--no-line-number",
        "--color=never", "--glob", "*.md", "^" .. field .. ": ", root,
    })

    -- rg exits 1 when there are simply no matches, which isn't an error here
    if vim.v.shell_error > 1 then
        vim.notify("ripgrep failed while scanning notes", vim.log.levels.ERROR)
        return {}
    end

    local entries = {}
    for _, line in ipairs(output) do
        -- Output is `path:field: value`. Anchoring the non-greedy path match on
        -- the literal field name keeps colons in the value from confusing it.
        local path, text = line:match("^(.-):" .. field .. ": (.*)$")
        if path and text ~= "" then
            local stamp = vim.fn.fnamemodify(path, ":t:r")
            table.insert(entries, {
                path = path,
                stamp = stamp,
                text = text,
                display = string.format("%-50s  %s-%s-%s", text,
                    stamp:sub(1, 4), stamp:sub(5, 6), stamp:sub(7, 8)),
            })
        end
    end

    table.sort(entries, function(a, b) return a.stamp > b.stamp end)
    return entries
end

-- Lua patterns treat these as operators, so a title containing one would
-- otherwise match the wrong text or fail outright.
local function escape_pattern(text)
    return (text:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

-- stamp -> title, for resolving [[20260725-193045]] back to prose. Rebuilt
-- lazily; render-markdown calls title_for() once per link on every redraw, so
-- this must never reach for ripgrep on the hot path.
local title_cache

local function titles_by_stamp()
    if not title_cache then
        title_cache = {}
        for _, entry in ipairs(scan("title")) do
            title_cache[entry.stamp] = entry.text
        end
    end
    return title_cache
end

function M.invalidate()
    title_cache = nil
end

function M.title_for(stamp)
    return titles_by_stamp()[stamp]
end

local function pick(opts)
    local entries = scan(opts.field)
    if #entries == 0 then
        vim.notify(string.format("No notes with a '%s:' field", opts.field), vim.log.levels.INFO)
        return
    end

    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    require("telescope.pickers").new({}, {
        prompt_title = opts.prompt,
        finder = require("telescope.finders").new_table({
            results = entries,
            entry_maker = function(entry)
                return {
                    value = entry,
                    path = entry.path,
                    display = entry.display,
                    ordinal = entry.text,
                }
            end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        previewer = require("telescope.config").values.file_previewer({}),
        attach_mappings = function(bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(bufnr)
                if selection then opts.on_select(selection.value) end
            end)
            return true
        end,
    }):find()
end

-- Full-text search across the vault.
--
-- Not `:Telekasten search_notes`: that seeds the prompt with the word under the
-- cursor, and since it calls builtin.live_grep it inherits the entry_maker from
-- telescope_config.lua, which shows only the filename. That display is right for
-- jumping around code but useless here, where the matching line is the point.
function M.grep()
    require("telescope.builtin").live_grep({
        prompt_title = "Search notes",
        cwd = root,
        search_dirs = { root },
        default_text = "",
        entry_maker = require("telescope.make_entry").gen_from_vimgrep({}),
    })
end

-- Browse every note by title
function M.titles()
    pick({
        field = "title",
        prompt = "Notes",
        on_select = function(entry) open(entry.path) end,
    })
end

-- Browse only the notes you've given an alias to
function M.bookmarks()
    pick({
        field = "alias",
        prompt = "Bookmarks",
        on_select = function(entry) open(entry.path) end,
    })
end

-- Tags are a flat inline list in the frontmatter: `tags: [ comedy, lists ]`.
-- Only what's inside the brackets counts, so splitting on commas and trimming
-- is the whole grammar. Quotes around a scalar are YAML's, not part of the tag.
local function parse_tags(text)
    local inner = text:match("^%s*%[(.*)%]%s*$")
    if not inner then return {} end

    local tags = {}
    for field in inner:gmatch("[^,]+") do
        local tag = vim.trim(field)
        tag = (tag:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1"))
        if tag ~= "" then table.insert(tags, tag) end
    end
    return tags
end

-- Every tagged note, newest first, with its tags pre-lowered for matching.
local function tagged_notes()
    local titles = titles_by_stamp()

    local notes = {}
    for _, entry in ipairs(scan("tags")) do
        local tags = parse_tags(entry.text)
        if #tags > 0 then
            local lowered = {}
            for i, tag in ipairs(tags) do lowered[i] = tag:lower() end

            local joined = table.concat(tags, ", ")
            local title = titles[entry.stamp] or ""
            table.insert(notes, {
                path = entry.path,
                tags = lowered,
                display = string.format("%-36s  %-40s  %s-%s-%s", joined, title,
                    entry.stamp:sub(1, 4), entry.stamp:sub(5, 6), entry.stamp:sub(7, 8)),
                ordinal = joined .. " " .. title,
            })
        end
    end
    return notes
end

-- Split a query into terms. Whitespace separates them; a double-quoted term has
-- to equal a tag outright, where a bare one only has to appear somewhere inside
-- one. An unclosed quote is read as bare, so the results narrow as you type it
-- rather than emptying out the moment the first quote lands.
local function parse_query(prompt)
    local terms = {}
    local pos = 1
    while true do
        local _, stop, quoted = prompt:find('^%s*"([^"]*)"', pos)
        if stop then
            if quoted ~= "" then
                table.insert(terms, { text = quoted:lower(), exact = true })
            end
        else
            local word
            _, stop, word = prompt:find("^%s*(%S+)", pos)
            if not stop then return terms end
            word = word:gsub('"', "")
            if word ~= "" then
                table.insert(terms, { text = word:lower(), exact = false })
            end
        end
        pos = stop + 1
    end
end

-- Terms are ANDed, but each one is free to match a different tag.
local function matches(note, terms)
    for _, term in ipairs(terms) do
        local hit = false
        for _, tag in ipairs(note.tags) do
            if (term.exact and tag == term.text)
                or (not term.exact and tag:find(term.text, 1, true)) then
                hit = true
                break
            end
        end
        if not hit then return false end
    end
    return true
end

-- Browse notes by tag.
--
-- Not `:Telekasten show_tags`: that lists the tags themselves, so picking one is
-- a second step and narrowing by two tags at once isn't possible at all. Here
-- the prompt filters notes directly, every term having to match some tag.
function M.tags()
    local notes = tagged_notes()
    if #notes == 0 then
        vim.notify("No tagged notes", vim.log.levels.INFO)
        return
    end

    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    require("telescope.pickers").new({}, {
        prompt_title = "Notes by tag",
        finder = require("telescope.finders").new_dynamic({
            fn = function(prompt)
                local terms = parse_query(prompt or "")
                local hits = {}
                for _, note in ipairs(notes) do
                    if matches(note, terms) then table.insert(hits, note) end
                end
                return hits
            end,
            entry_maker = function(note)
                return {
                    value = note,
                    path = note.path,
                    display = note.display,
                    ordinal = note.ordinal,
                }
            end,
        }),
        -- The finder has already applied the query, and applying it twice is
        -- wrong here: a fuzzy sorter scores against the whole display line, so
        -- it would both drop legitimate matches and re-admit rows on a hit in
        -- the title or the date. Empty scores everything equally, which leaves
        -- the finder's newest-first order intact.
        sorter = require("telescope.sorters").empty(),
        previewer = require("telescope.config").values.file_previewer({}),
        attach_mappings = function(bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(bufnr)
                if selection then open(selection.value.path) end
            end)
            return true
        end,
    }):find()
end

-- A daily note is an ordinary note tagged `daily` and titled with its date, so
-- it shows up in every picker here without special handling.
--
-- Nothing parses the body for the date, and no frontmatter field holds it
-- either: filenames are creation timestamps, so the date is already the first
-- eight characters of the basename. That makes the file list its own calendar --
-- sorting it is chronological order, and days you didn't write on are simply
-- absent, which is exactly the "skip the gaps" behaviour navigation wants.
local function daily_notes()
    local paths = {}
    for _, entry in ipairs(scan("tags")) do
        for _, tag in ipairs(parse_tags(entry.text)) do
            if tag:lower() == "daily" then
                table.insert(paths, entry.path)
                break
            end
        end
    end

    -- scan() sorts newest first; the timeline reads the other way
    table.sort(paths, function(a, b) return vim.fs.basename(a) < vim.fs.basename(b) end)
    return paths
end

-- Open today's daily note, writing it first if this is the day's first visit.
function M.daily()
    local today = os.date("%Y%m%d")
    for _, path in ipairs(daily_notes()) do
        if vim.fs.basename(path):sub(1, 8) == today then
            open(path)
            return
        end
    end

    create(os.date("%Y-%m-%d"), { "daily" })
end

function M.previous_daily() step_through(daily_notes(), -1, "daily note") end

function M.next_daily() step_through(daily_notes(), 1, "daily note") end

-- Links are [[destination|display]] -- the only order either plugin understands.
-- Telekasten follows the destination, render-markdown conceals it, so the
-- timestamp never has to be readable in prose. Retype the alias to whatever
-- reads best at the callsite; nothing here depends on it matching the title.
function M.insert_link()
    pick({
        field = "title",
        prompt = "Insert link to note",
        on_select = function(entry)
            vim.api.nvim_put({ "[[" .. entry.stamp .. "|" .. entry.text .. "]]" }, "c", true, true)
        end,
    })
end

-- The capture from the first span matching `pattern` that contains the cursor.
-- Scanning for the span the cursor falls inside means a line can hold several.
local function span_at_cursor(pattern)
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- byte index, 1-based
    local init = 1
    while true do
        local s, e, inner = line:find(pattern, init)
        if not s then return nil end
        if col >= s and col <= e then return inner end
        init = e + 1
    end
end

-- The [[...]] span containing the cursor, or nil.
function M.link_at_cursor()
    return span_at_cursor("%[%[(.-)%]%]")
end

-- Whether follow() has anything to act on, so a mapping can fall back to the
-- key's normal meaning instead of firing into nothing.
function M.followable()
    return M.link_at_cursor() ~= nil or span_at_cursor("%[.-%]%((.-)%)") ~= nil
end

local function path_for(stamp)
    return vim.fn.glob(root .. "/[0-9][0-9][0-9][0-9]/" .. stamp .. ".md", false, true)[1]
end

-- Jump straight to the linked note.
--
-- `:Telekasten follow_link` resolves the destination correctly but then always
-- hands off to a telescope picker seeded with it, even when the note exists, so
-- every jump costs an extra <CR>. Plain [[<stamp>]] links are handled here;
-- heading refs, paragraph refs and markdown [text](url) go to telekasten.
--
-- Delegation is deliberately narrow. follow_link yanks whatever is under the
-- cursor and interpolates it into a :normal command, so handing it arbitrary
-- prose throws E114 as soon as the text contains a quote.
function M.follow()
    local inner = M.link_at_cursor()
    if inner then
        local dest = vim.trim(inner:match("^([^|]*)") or "")
        if dest:match("^%d%d%d%d%d%d%d%d%-%d%d%d%d%d%d$") then
            local path = path_for(dest)
            if path then
                open(path)
            else
                vim.notify("No note " .. dest, vim.log.levels.WARN)
            end
            return
        end
        return require("telekasten").follow_link()
    end

    if span_at_cursor("%[.-%]%((.-)%)") then
        return require("telekasten").follow_link()
    end

    vim.notify("No link under the cursor", vim.log.levels.INFO)
end

-- Locate the frontmatter `title:` line, returning its value and 1-based number.
local function find_title(lines)
    if lines[1] ~= "---" then return nil end
    for i = 2, #lines do
        if lines[i] == "---" then return nil end
        local title = lines[i]:match("^title:%s*(.*)$")
        if title then return title, i end
    end
end

-- An alias is prose chosen at the callsite, so only the ones that were the title
-- verbatim are stale. `[[<stamp>|here]]` is a deliberate choice and survives.
local function update_aliases(stamp, old, new)
    local files = vim.fn.systemlist({
        "rg", "--files-with-matches", "--fixed-strings",
        "--glob", "*.md", stamp, root,
    })
    if vim.v.shell_error > 1 then
        vim.notify("ripgrep failed while updating links", vim.log.levels.ERROR)
        return 0
    end

    -- The stamp needs escaping too: its `-` is a Lua quantifier. remove_alias
    -- splits on `%s*|`, so telekasten tolerates padding around the pipe and this
    -- has to match the same links telekasten would follow.
    local pattern = "%[%[" .. escape_pattern(stamp) .. "%s*|%s*" .. escape_pattern(old) .. "%]%]"
    local replacement = "[[" .. stamp .. "|" .. new .. "]]"

    local count = 0
    for _, file in ipairs(files) do
        local lines = vim.fn.readfile(file)
        local changed = false
        for i, line in ipairs(lines) do
            -- Replacing via a function keeps any `%` in the new title literal
            local result, n = line:gsub(pattern, function() return replacement end)
            if n > 0 then
                lines[i] = result
                changed = true
            end
        end
        if changed then
            vim.fn.writefile(lines, file)
            count = count + 1
        end
    end
    return count
end

-- Change a note's title.
--
-- Not `:Telekasten rename_note`: that assumes the filename is the title, so it
-- writes a copy to the vault root, fails to remove the original (it looks for it
-- there too), and rewrites every [[stamp]] link to point at the copy. Filenames
-- here are permanent timestamps, so there is nothing to rename but the field.
function M.retitle()
    local path = vim.fn.expand("%:p")
    local stamp = vim.fn.fnamemodify(path, ":t:r")

    -- Refuse anything that isn't a note, so a stray buffer can't trigger a
    -- vault-wide link rewrite
    if not path:match("^" .. escape_pattern(root) .. "/%d%d%d%d/")
        or not stamp:match("^%d%d%d%d%d%d%d%d%-%d%d%d%d%d%d$") then
        vim.notify("Not a note", vim.log.levels.WARN)
        return
    end

    local old, lnum = find_title(vim.api.nvim_buf_get_lines(0, 0, -1, false))
    if not old then
        vim.notify("No 'title:' in frontmatter", vim.log.levels.WARN)
        return
    end

    vim.ui.input({ prompt = "Title: ", default = old }, function(new)
        if not new or new == "" or new == old then return end

        -- Write before scanning: this note may link to itself, and update_aliases
        -- reads from disk
        vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { "title: " .. new })
        vim.cmd("write")

        local updated = update_aliases(stamp, old, new)
        M.invalidate()
        vim.cmd.checktime()

        vim.notify(string.format("Retitled to %q (%d linking note%s updated)",
            new, updated, updated == 1 and "" or "s"))
    end)
end

return M

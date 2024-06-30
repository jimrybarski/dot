-- Functions to help me type pinyin. When the cursor is over a vowel, typing <leader>p will cycle the vowel through
-- the various tone markers (or in the case of "u", it will also go through "ü" and its tones).


function cycle_pinyin_tones()
    local vowels = {
        ['a'] = 'à',
        ['à'] = 'ǎ',
        ['ǎ'] = 'á',
        ['á'] = 'ā',
        ['ā'] = 'a',
        ['e'] = 'é',
        ['é'] = 'ē',
        ['ē'] = 'ě',
        ['ě'] = 'è',
        ['è'] = 'e',
        ['i'] = 'í',
        ['í'] = 'ī',
        ['ī'] = 'ǐ',
        ['ǐ'] = 'ì',
        ['ì'] = 'i',
        ['o'] = 'ō',
        ['ō'] = 'ó',
        ['ó'] = 'ǒ',
        ['ǒ'] = 'ò',
        ['ò'] = 'o',
        ['u'] = 'ū',
        ['ū'] = 'ú',
        ['ú'] = 'ǔ',
        ['ǔ'] = 'ù',
        ['ù'] = 'ǖ',
        ['ǖ'] = 'ǘ',
        ['ǘ'] = 'ǚ',
        ['ǚ'] = 'ǜ',
        ['ǜ'] = 'ü',
        ['ü'] = 'u',
    }

    local bufnr = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1

    local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
    -- Vowels with accents are two chars wide so we have to handle the possibility of either width
    local char = line:sub(col + 1, col + 1)
    local widechar = line:sub(col + 1, col + 2)

    -- Make sure the cursor is over a vowel in our table
    local next_char = vowels[char] or vowels[widechar]
    if not next_char then
        return
    end

    local plain_vowels = "aeiou"
    if string.find(plain_vowels, char) then
        -- we're replacing a 1-byte character
        new_line = line:sub(1, col) .. next_char .. line:sub(col + 2)
    else
        -- we're replacing a 2-byte character
        new_line = line:sub(1, col) .. next_char .. line:sub(col + 3)
    end

    -- Update the text of the current line
    vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, {new_line})
    -- Move the cursor so the user thinks it's in the same place as it was before the change
    vim.api.nvim_win_set_cursor(0, {row + 1, col})
end

-- Create a command for easier usage
vim.api.nvim_create_user_command('CyclePinyinTones', cycle_pinyin_tones, {})

-- Optionally, you can create a keymap for easier access
vim.api.nvim_set_keymap('n', '<leader>p', ':CyclePinyinTones<CR>', { noremap = true, silent = true })

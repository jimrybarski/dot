bio = require("bioinformatics")

function set_query_visual() 
    local seq = bio.get_visual_selection()
    bio.set_pairwise_query(seq) 
end

function set_subject_visual() 
    local seq = bio.get_visual_selection()
    bio.set_pairwise_subject(seq)
end

function set_query_current_word()
    local seq = vim.fn.expand("<cword>")
    bio.set_pairwise_query(seq) 
end

function set_subject_current_word()
    local seq = vim.fn.expand("<cword>")
    bio.set_pairwise_subject(seq) 
end

function set_subject_current_word_and_align()
    local seq = vim.fn.expand("<cword>")
    bio.set_pairwise_subject(seq) 
    local alignment = bio.pairwise_align()
    bio.display_alignment(alignment)
end

vim.keymap.set('v', '<leader>bva', set_query_visual, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>bvb', set_subject_visual, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ba', set_query_current_word, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bb', set_subject_current_word_and_align, { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, '<leader>bp', bio.pairwise_align, { noremap = true, silent = true })

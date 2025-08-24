bio = require("bioinformatics")

function set_query_visual()
    local seq = bio.get_visual_selection()
    bio.set_pairwise_query(seq)
end

function set_subject_visual_and_align()
    local seq = bio.get_visual_selection()
    bio.set_pairwise_subject(seq)
    local alignment = bio.pairwise_align({use_0_based_coords = true})
    bio.display_text(alignment)
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
    local alignment = bio.pairwise_align({use_0_based_coords = true})
    bio.display_text(alignment)
end

function popup_stats()
    local seq = bio.get_visual_selection()
    local gc_content = bio.gc_content(seq)
    local length = bio.length(seq)
    local text = string.format("GC: %.6f\nLen: %d bp", gc_content, length)
    vim.notify(text)
end

function popup_stats_current_word()
    local seq = vim.fn.expand("<cword>")
    local gc_content = bio.gc_content(seq)
    local length = bio.length(seq)
    local text = string.format("GC: %.6f\nLen: %d bp", gc_content, length)
    vim.notify(text)
end

function search_for_rc_current_word()
    local seq = vim.fn.expand("<cword>")
    local revcomp = bio.reverse_complement(seq)
    bio.search_for_string(revcomp)
end

function search_for_current_word()
    local seq = vim.fn.expand("<cword>")
    bio.search_for_string(seq)
end

function put_rc_in_register()
    local seq = vim.fn.expand("<cword>")
    local revcomp = bio.reverse_complement(seq)
    vim.fn.setreg('+', revcomp, "l")
end

function put_rc_in_register_visual()
    local seq = vim.fn.expand("<cword>")
    local revcomp = bio.reverse_complement(seq)
    vim.fn.setreg('+', revcomp, "l")
end

vim.keymap.set('n', '<leader>ba', set_query_current_word, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>ba', set_query_visual, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>bb', set_subject_current_word_and_align, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>bb', set_subject_visual_and_align, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>bs', popup_stats_current_word, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>bs', popup_stats, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>brf', search_for_rc_current_word, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bf', search_for_current_word, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bry', put_rc_in_register, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>bry', put_rc_in_register_visual, { noremap = true, silent = true })

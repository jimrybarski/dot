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
    bio.display_text(alignment)
end

function run_alignment()
    local alignment = bio.pairwise_align()
    bio.display_text(alignment)
end

function popup_stats()
    local seq = bio.get_visual_selection()
    local gc_content = bio.gc_content_biotools(seq)
    local gc_content_text = string.format("GC: %.6f", gc_content)
    local length = bio.length_biotools(seq)
    local length_text = string.format("Len: %d bp", length)
    bio.display_text({gc_content_text, length_text})
end

vim.keymap.set('v', '<leader>bva', set_query_visual, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>bvb', set_subject_visual, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>bvs', popup_stats, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ba', set_query_current_word, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bb', set_subject_current_word_and_align, { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, '<leader>bp', run_alignment, { noremap = true, silent = true })

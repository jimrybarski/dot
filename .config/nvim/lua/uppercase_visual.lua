local function print_visual_selection_uppercase()
  -- Get the current buffer and start and end positions of the selection
  print("hello")
end
  -- Extract the lines within the visual selection range
--   local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[2] - 1, end_pos[2], false)
--
--   -- If the selection is within a single line, trim to the selection range
--   if start_pos[2] == end_pos[2] then
--     lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
--   else
--     -- Adjust the start and end lines to the correct column positions
--     lines[1] = string.sub(lines[1], start_pos[3])
--     lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
--   end
--
--   -- Concatenate all selected lines and convert to uppercase
--   local selected_text = table.concat(lines, "\n")
--   print(selected_text)
-- end
--
-- -- Register the function as a command in visual mode
-- vim.api.nvim_set_keymap('v', '<C-t>', [[:lua require'uppercase_visual'()<CR>]], { noremap = true, silent = true })

-- Return the function to make it accessible
return {
  print_visual_selection_uppercase = print_visual_selection_uppercase
}

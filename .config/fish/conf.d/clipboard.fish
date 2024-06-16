# This function copies highlighted text to the system clipboard
function fish_clipboard_copy
    set -l selected_text (commandline --cut-at-cursor)
    if test -n "$selected_text"
        echo -n $selected_text | xclip -selection clipboard
    end
    commandline -f cancel
end

# Bind <leader>y to copy the highlighted text in visual mode.
# This mirrors the binding in my nvim config.
bind -M visual ' 'y 'fish_clipboard_copy'

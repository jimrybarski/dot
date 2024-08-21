# Don't do annoying fish completion that cycles through options and doesn't fully complete paths.
function fish_user_key_bindings
    bind -M insert \t 'commandline -f complete; commandline -f repaint'
end

set -g fish_complete_cycle false
set -U fish_complete_path 0
set -U fish_complete_scope 2

# Don't do annoying fish completion that cycles through options and doesn't fully complete paths.
# Plain `complete` never cycles; the default tab binding escalates to complete-and-search.
function fish_user_key_bindings
    bind -M insert \t 'commandline -f complete; commandline -f repaint'
end

# NOTE: do not set fish_complete_path here. Overriding it drops fish's bundled
# completions ($__fish_data_dir/completions), which is where git.fish and friends live.
# ~/.config/fish/completions is already first in the default path, so ours still win.

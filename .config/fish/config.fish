# theme_gruvbox dark medium
if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    exec startx
end

source $XDG_CONFIG_HOME/fish/conf.d/prompt.fish

for file in $XDG_CONFIG_HOME/fish/conf.d/*/*.fish
    source $file
end

umask 027

# Don't have a message on startup.
set -U fish_greeting

# Use the vi keybindings while retaining emacs control sequences
# This lets us use ctrl+f to select the autocomplete suggestion
fish_hybrid_key_bindings

fzf --fish | source

set -x GPG_TTY (tty)
set -x LANG en_US.UTF-8
set -x LC_ADDRESS "en_US.UTF-8"
set -x LC_COLLATE "en_US.UTF-8"
set -x LC_CTYPE "en_US.UTF-8"
set -x LC_IDENTIFICATION "en_US.UTF-8"
set -x LC_MEASUREMENT "en_US.UTF-8"
set -x LC_MESSAGES "en_US.UTF-8"
set -x LC_MONETARY "en_US.UTF-8"
set -x LC_NAME "en_US.UTF-8"
set -x LC_NUMERIC "en_US.UTF-8"
set -x LC_PAPER "en_US.UTF-8"
set -x LC_TELEPHONE "en_US.UTF-8"
set -x LC_TIME "en_US.UTF-8"
set -x XDG_CONFIG_HOME "$HOME/.config"

# set $PATH
set -U fish_user_paths $HOME/.cargo/bin $HOME/.local/bin $fish_user_paths

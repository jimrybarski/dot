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
set -x LIBCLANG_PATH "/home/jim/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-18.1.2_20240912/esp-clang/lib"

set -U fish_user_paths $HOME/.local/sra/bin $HOME/.cargo/bin $HOME/.local/bin /usr/local/go/bin $HOME/.rustup/toolchains/esp/xtensa-esp-elf/esp-14.2.0_20240906/xtensa-esp-elf/bin $HOME/.luarocks/bin $fish_user_paths

set -x SHELL $HOME/.local/bin/fish

# set my editor with fallback options in case I'm in a new environment
set -l editors nvim vim vi nano

for editor in $editors
    if which $editor > /dev/null
        set -x EDITOR $editor
        break
    end
end

# load custom env vars
if test -e $HOME/.custom-env
    source $HOME/.custom-env
end

#!/usr/bin/env zsh

# ---------------
#     Aliases
# ---------------
alias ll='eza -alh'
alias ls='eza -a'
alias v='nvim'
alias sf="ssh freeboxroot"
alias sm="ssh marble"
alias ss="ssh stampede"
alias sw="ssh wilke"
alias sw2="ssh wilke2"
alias eba=". env/bin/activate"

# notes
alias todo="edit_note todo"
alias tv="edit_note tv"
alias comedians="edit_note comedians"

# rust
alias cbr='cargo test && cargo build --release && cargo clippy'
alias crr='cargo run --release'

# git
alias gits='git status'
alias gitc="GIT_EDITOR='nvim +startinsert' git commit"
alias gitcs="GIT_EDITOR='nvim +startinsert' git commit -S"

# screen brightness
alias bright='redshift -o -P -O 5000 -b 1.0'
alias day='redshift -o -P -O 3800 -b 0.75'
alias night='redshift -o -P -O 2500 -b 0.60'

# configuration files
alias cfv="v $HOME/.config/nvim/init.lua"
alias cfz="v $HOME/.zshrc"
alias cfi3="v $HOME/.config/i3/config"
alias cfib="v $HOME/.config/i3blocks/config"
alias cfn=v "$HOME/.config/ncmpcpp/config"

alias copy="xsel --clipboard"

alias m='ncmpcpp'


export GPG_TTY=$(tty)
export XDG_CONFIG_HOME="$HOME/.config"

setopt share_history inc_append_history hist_reduce_blanks sharehistory extended_history append_history
HISTSIZE=100000000
SAVEHIST=100000000
HISTFILE=$HOME/.zsh_history
bindkey -v
bindkey '^R' history-incremental-search-backward

PROMPT="%B%F{10}%n@%m%f%b [%*] [%(?.%F{10}√%f.%F{9}%?%f)] %d %F{12}$%f "
PATH="$HOME/.cargo/bin:$PATH"

# Locale
LANG=en_US.UTF-8
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"

# Causes the timezone to be cached, preventing unnecessary system calls
#export TZ=:/etc/localtime

# only wait 0.1 sec before entering normal mode
export KEYTIMEOUT=0.1

# try to pick the optimal editor, falling back to increasingly worse options
EDITOR=$(for binary in nvim vim vi nano; do p=$(which $binary | grep -v "not found"); if [[ -n $p ]]; then echo $p; break; fi; done)

umask 027


# Git
pull() {
    local branch=$(git symbolic-ref --short HEAD)
    git pull origin "$branch"
}
push() {
    local branch=$(git symbolic-ref --short HEAD)
    git push origin "$branch"
}

# Finds files in the current directory with spaces and replaces the spaces with underscores
function fixspaces() {
    for file in *' '*; 
        do mv -- "$file" "${file// /_}"; 
    done
}

# Linux has dircolors, FreeBSD has gdircolors
dircolors_exec=$(for binary in dircolors gdircolors; do p=$(which "$binary" | grep -v "not found"); if [[ -n "$p" ]]; then echo "$p"; break; fi; done)

if [[ -n "$dircolors_exec" ]]; then
    eval "$($dircolors_exec -b)"
fi


function print_colors() {
	# displays the eight font/background colors we can use in the terminal
	printf "|039| \033[39mDefault \033[m  |049| \033[49mDefault \033[m  |037| \033[37mLight gray \033[m     |047| \033[47mLight gray \033[m\n"
	printf "|030| \033[30mBlack \033[m    |040| \033[40mBlack \033[m    |090| \033[90mDark gray \033[m      |100| \033[100mDark gray \033[m\n"
	printf "|031| \033[31mRed \033[m      |041| \033[41mRed \033[m      |091| \033[91mLight red \033[m      |101| \033[101mLight red \033[m\n"
	printf "|032| \033[32mGreen \033[m    |042| \033[42mGreen \033[m    |092| \033[92mLight green \033[m    |102| \033[102mLight green \033[m\n"
	printf "|033| \033[33mYellow \033[m   |043| \033[43mYellow \033[m   |093| \033[93mLight yellow \033[m   |103| \033[103mLight yellow \033[m\n"
	printf "|034| \033[34mBlue \033[m     |044| \033[44mBlue \033[m     |094| \033[94mLight blue \033[m     |104| \033[104mLight blue \033[m\n"
	printf "|035| \033[35mMagenta \033[m  |045| \033[45mMagenta \033[m  |095| \033[95mLight magenta \033[m  |105| \033[105mLight magenta \033[m\n"
	printf "|036| \033[36mCyan \033[m     |046| \033[46mCyan \033[m     |096| \033[96mLight cyan \033[m     |106| \033[106mLight cyan \033[m\n"
}


# Edit markdown notes at remote server with zsh/neovim
function derive_note_filename () {
    filename=$1
    suffix=$2
    if [[ -z "$suffix" ]]; then
        suffix="md"
    fi
    echo "$filename.$suffix"
}

function edit_note () {
    filename=$(derive_note_filename $1 $2)
    directory=$(dirname $filename)
    osname=$(uname)
    if [[ "$osname" != "Darwin" ]]; then
        ssh notes -t "/usr/local/bin/zsh -ic 'mkdir -p ~/notes/$directory && v ~/notes/$filename'"
    else
        mkdir -p "$HOME/notes/$directory" && v "$HOME/notes/$filename"
    fi
}

alias en=edit_note

function echo_note () {
    filename=$(derive_note_filename $1 $2)
    if [[ "$osname" != "Darwin" ]]; then
        ssh notes cat "/root/notes/$filename"
    else
        cat $HOME/notes/$filename
    fi
}
alias echon=echo_note

# -------------------
# Enable autocomplete
# -------------------
autoload -Uz compinit && compinit
autoload -Uz colors && colors

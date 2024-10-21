# system management
alias upgrade='sudo pacman -Syu; /usr/bin/setxkbmap -option caps:escape'

# config files
alias cff='v $HOME/.config/fish/config.fish --cmd "cd $HOME/.config/fish"'
alias cfi3='v $HOME/.config/i3/config'
alias cfib='v $HOME/.config/i3blocks/config'
alias cfn='v $HOME/.config/ncmpcpp/config'
alias cfv='v $HOME/.config/nvim/init.lua --cmd "cd $HOME/.config/nvim"'
alias cft='v $HOME/.config/tmux/tmux.conf'
alias cftr='v $HOME/.config/tmuxinator/'

# shortened
alias cl='cal -3'
alias cly='cal -y'
alias copy='xsel --clipboard'
alias ll="eza -alh"
alias llm='/home/jim/.local/llmenv/bin/llm'
alias dalle='/home/jim/.local/llmenv/bin/python /home/jim/scripts/dalle.py'
alias ls="eza -a"
alias m='ncmpcpp'
alias v="nvim"
alias sf="ssh freebox"
alias diceware="shuf $HOME/code/diceware/wordlists/en_US/wordlist.txt | head -n 6"

# notes
alias comedians='edit_note comedians'
alias echon='echo_note'
alias en='edit_note'
alias todo='edit_note todo'
alias tv='edit_note tv'
alias ug='edit_note ug'

# programming
alias cbr='cargo test && cargo build --release && cargo clippy'
alias crr='cargo run --release'
alias eba=". env/bin/activate.fish"
alias gitc="env GIT_EDITOR='nvim +startinsert' git commit"
alias gitcs="env GIT_EDITOR='nvim +startinsert' git commit -S"
alias gits='git status'
alias pull="git pull"
alias push="git push"

# screen
alias bright='redshift -o -P -O 5000 -b 1.0'
alias day='redshift -o -P -O 3800 -b 0.75'
alias night='redshift -o -P -O 2500 -b 0.60'

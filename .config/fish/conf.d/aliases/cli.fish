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

# config directories
alias cdv='cd $HOME/dot/.config/nvim'
alias cdf='cd $HOME/dot/.config/fish'

# tmuxinator 
alias blog='tmuxinator blog'

# shortened
alias cl='cal -3'
alias cly='cal -y'
alias copy='xsel --clipboard'
alias ll="eza -alh"
alias ls="eza -a"
alias v="nvim"
alias sf="ssh freebox"
alias diceware="shuf $HOME/code/diceware/wordlists/en_US/wordlist.txt | head -n 6"
alias sciine="/home/jim/.local/asciinema-edit-env/bin/sciine"

# programming
alias cbr='cargo test && cargo build --release && cargo clippy'
alias crr='cargo run --release'
alias vt='v Cargo.toml'
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

# science
alias rc='biotools reverse-complement'
alias len='biotools length'
alias gc='biotools gc-content'
alias pw='biotools pairwise-semiglobal --try-rc'
alias pwl='biotools pairwise-local --try-rc'
alias pwg='biotools pairwise-global --try-rc'

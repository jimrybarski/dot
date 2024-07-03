#!/usr/bin/env fish
# Function to strip color codes

env -i

if [ $(pushd $HOME/dot > /dev/null && git status --porcelain | wc -l && popd >/dev/null) ]
    echo "Sync dotfiles!"
else
    echo ""
end 

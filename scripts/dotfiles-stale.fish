#!/usr/bin/env fish
# Function to strip color codes

env -i

pushd $HOME/dot > /dev/null 

if [ $(git status --porcelain) ]
    echo "Sync dotfiles!"
else
    echo ""
end 

popd >/dev/null

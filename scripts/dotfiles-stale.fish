#!/usr/bin/env fish
# Function to strip color codes

env -i

if [ $(pushd ~/dot > /dev/null && git status --porcelain | wc -l && popd >/dev/null) ]
    echo ""
else
    echo "Sync dotfiles!"
end 

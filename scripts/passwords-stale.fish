#!/usr/bin/env fish
# Function to strip color codes

env -i

if [ $(pushd ~/.password-store > /dev/null && git status | grep ahead && popd >/dev/null) ]
    echo "Sync passwords!"
else
    echo ""
end 

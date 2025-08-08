#!/usr/bin/env bash

set -euo pipefail

for filename in .gitignore; do
    >&2 echo "$filename"
    if [ -z $filename ]; then
	    echo "Error! Empty filename. Something is very wrong with this script."
        exit 1
    fi
    rm -f "$HOME/$filename"
    mkdir -p $(dirname "$HOME/$filename")
    ln -s "$PWD/$filename" $HOME/$filename
    >&2 echo "linked $filename to $HOME/$filename"
done

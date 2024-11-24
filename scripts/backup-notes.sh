#!/usr/bin/env bash

set -euo pipefail

pushd $HOME
tar -czf notes.tar.gz -C $HOME notes
gpg --encrypt --armor --recipient "James Rybarski <jim@rybarski.com>" --output notes.tar.gz.gpg notes.tar.gz
rm notes.tar.gz
scp notes.tar.gz.gpg root@notes:
rm notes.tar.gz.gpg
popd

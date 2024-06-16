#/usr/bin/env fish
# Edit markdown notes at remote server with fish/neovim

function derive_note_filename
    set filename $argv[1]
    set suffix $argv[2]
    if test -z "$suffix"
        set suffix "md"
    end
    echo "$filename.$suffix"
end

function edit_note
    set filename (derive_note_filename $argv[1] $argv[2])
    set directory (dirname $filename)
    set osname (uname)
    if test "$osname" != "Darwin"
        ssh notes -t "/usr/local/bin/zsh -ic 'mkdir -p ~/$directory && v ~/$filename'"
    else
        mkdir -p "$HOME/notes/$directory" && v "$HOME/notes/$filename"
    end
end

function echo_note
    set filename (derive_note_filename $argv[1] $argv[2])
    if test "$osname" != "Darwin"
        ssh notes cat "/root/$filename"
    else
        cat "$HOME/notes/$filename"
    end
end

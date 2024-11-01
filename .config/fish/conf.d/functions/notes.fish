#/usr/bin/env fish

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
    mkdir -p "$HOME/notes/$directory" && v "$HOME/notes/$filename"
end

function echo_note
    set filename (derive_note_filename $argv[1] $argv[2])
    cat "$HOME/notes/$filename"
end

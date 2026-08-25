# On YouTube URLs, drop every query parameter except v (playlist, tracking,
# timestamp junk). youtu.be carries the id in the path, so it just loses its
# whole query string. Everything else is passed through untouched.
function _yt_clean_url
    for arg in $argv
        set -l parts (string split -m1 '?' -- $arg)
        if test (count $parts) -lt 2
            printf '%s\n' $arg
            continue
        end
        set -l base $parts[1]
        set -l host (string lower (string replace -r '^(?:https?://)?([^/?#]+).*$' '$1' -- $base))
        if not contains -- $host youtube.com www.youtube.com youtu.be www.youtu.be
            printf '%s\n' $arg
            continue
        end
        set -l rest (string split -m1 '#' -- $parts[2])
        set -l keep
        for param in (string split '&' -- $rest[1])
            if string match -q 'v=*' -- $param
                set -a keep $param
            end
        end
        set -l out $base
        if test (count $keep) -gt 0
            set out "$base?"(string join '&' $keep)
        end
        if test (count $rest) -gt 1
            set out "$out#$rest[2]"
        end
        printf '%s\n' $out
    end
end

function vid
    "$HOME/.local/ytdlenv/bin/yt-dlp" --no-cookies --impersonate chrome --embed-thumbnail -o "$HOME/%(title)s.%(ext)s" (_yt_clean_url $argv)
end

function mp3
    "$HOME/.local/ytdlenv/bin/yt-dlp" --no-cookies --impersonate chrome -x --audio-format mp3 -o '%(title)s.%(ext)s' (_yt_clean_url $argv)
end

function pastevid
    set url (xclip -o -sel clip)
    notify-send "Downloading video: $url"
    vid $url
    notify-send "Done downloading video: $url"
end

function pastemp3
    set url (xclip -o -sel clip)
    notify-send "Downloading mp3: $url"
    mp3 $url
    notify-send "Done downloading mp3: $url"
end

function ytupdate
    $HOME/.local/ytdlenv/bin/pip install -U yt-dlp
end

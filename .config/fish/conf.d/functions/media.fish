function vid
    "$HOME/.local/ytdlenv/bin/yt-dlp" --no-cookies --impersonate chrome --embed-thumbnail -o '$HOME/%(title)s.%(ext)s' "$argv"
end

function mp3
    "$HOME/.local/ytdlenv/bin/yt-dlp" --no-cookies --impersonate chrome -x --audio-format mp3 -o '%(title)s.%(ext)s' "$argv"
end

function vid2mp3
    "$HOME/.local/ytdlenv/bin/yt-dlp" --no-cookies --impersonate chrome -x --audio-format mp3 --enable-file-urls -o '$HOME/%(title)s.%(ext)s' -- "file:$HOME/%(title)s.%(ext)s"
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

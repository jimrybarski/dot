function vid
    "$HOME/.local/ytdlenv/bin/yt-dlp" -o '$HOME/%(title)s.%(ext)s' "$argv"
end

function mp3
    "$HOME/.local/ytdlenv/bin/yt-dlp" -x --audio-format mp3 -o '%(title)s.%(ext)s' "$argv"
end

function vid2mp3
    "$HOME/.local/ytdlenv/bin/yt-dlp" -x --audio-format mp3 --enable-file-urls -o '$HOME/%(title)s.%(ext)s' -- "file:$HOME/%(title)s.%(ext)s"
end

function archive
    set URL "$argv"
    set VIDEO_PATH "$HOME/Videos"
    set MUSIC_PATH "$HOME/Music"
    set FILENAME ("$HOME/.local/ytdlenv/bin/yt-dlp" --get-filename -o "$VIDEO_PATH/%(title)s.%(ext)s" "$URL")
    "$HOME/.local/ytdlenv/bin/yt-dlp" -x --enable-file-urls --audio-format mp3 -o "$MUSIC_PATH/%(title)s.%(ext)s" -- "file:$FILENAME"
    "$HOME/.local/ytdlenv/bin/yt-dlp" -o "$FILENAME" "$URL"
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

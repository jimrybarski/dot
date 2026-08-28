/usr/bin/setxkbmap -option caps:escape
# pins font DPI and cursor size, which X would otherwise derive from whichever
# displays are attached -- must come before anything that reads them
xrdb -merge $HOME/.Xresources
$HOME/.local/bin/fish $HOME/dot/scripts/tv.fish auto
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
/usr/bin/fcitx &
/usr/bin/dunst &
xmodmap ~/.config/xmodmap
exec dbus-run-session i3

/usr/bin/setxkbmap -option caps:escape
$HOME/.local/bin/fish $HOME/dot/scripts/tv.fish auto
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
/usr/bin/fcitx &
/usr/bin/dunst &
xmodmap ~/.config/xmodmap
exec dbus-run-session i3

/usr/bin/setxkbmap -option caps:escape
/usr/bin/xrandr --output DisplayPort-1 --primary --mode 3440x1440 --rate 165
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
/usr/bin/fcitx &
/usr/bin/flameshot &
/usr/bin/dunst &
xmodmap ~/.config/xmodmap
exec i3

#!/usr/bin/env fish
#
# Attach or detach the TV on HDMI-0.
#
#   tv.fish auto     configure for whatever is plugged in right now (used at login)
#   tv.fish on       extend onto the TV
#   tv.fish off      drive the ultrawide alone
#   tv.fish toggle   flip between the two
#
# The TV reports as disconnected while it is powered off, so `auto` does the
# right thing at boot whether or not it happens to be on.

set -l main DP-0
set -l main_mode 3440x1440
set -l main_rate 164.90
set -l tv HDMI-0
set -l tv_mode 1920x1080
set -l tv_rate 60

# plugged: the TV is powered on and handshaking
# active:  it is already part of the desktop
set -l plugged 0
set -l active 0
for line in (xrandr --query)
    if string match -q "$tv connected*" -- $line
        set plugged 1
        if string match -qr "^$tv connected (primary )?[0-9]+x[0-9]+\+" -- $line
            set active 1
        end
    end
end

set -l action $argv[1]
test -z "$action"; and set action auto

if test "$action" = toggle
    if test $active -eq 1
        set action off
    else
        set action on
    end
end

if test "$action" = auto
    if test $plugged -eq 1
        set action on
    else
        set action off
    end
end

# Both outputs go in a single xrandr call so the change applies atomically,
# rather than flickering through an intermediate layout.
switch $action
    case on
        if test $plugged -eq 0
            notify-send "TV not detected" "Turn the TV on and select the HDMI input, then try again."
            exit 1
        end
        xrandr --output $main --primary --mode $main_mode --rate $main_rate \
               --output $tv --mode $tv_mode --rate $tv_rate --left-of $main
    case off
        xrandr --output $main --primary --mode $main_mode --rate $main_rate \
               --output $tv --off
    case '*'
        echo "usage: tv.fish [auto|on|off|toggle]" >&2
        exit 2
end

# i3 moves its own workspaces around, but the wallpaper has to be repainted
# for the new screen geometry. ~/.fehbg replays whatever feh last set, so this
# keeps working if the wallpaper changes. Never let it fail the whole script.
if test -x $HOME/.fehbg
    $HOME/.fehbg >/dev/null 2>&1
end
exit 0

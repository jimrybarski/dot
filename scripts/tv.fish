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
#
# The TV also needs ForceFullCompositionPipeline to stop tearing -- see
# tearfree below.

set -l main DP-0
set -l main_mode 3440x1440
set -l main_rate 164.90
set -l tv HDMI-0
set -l tv_mode 3840x2160
# The panel also advertises 3840x2160 at 164.99, and it trains and stays RGB.
# 120 is the better default anyway: this screen mostly plays video, and 24p and
# 30p divide evenly into it, where 165 pulls them down unevenly and judders.
# Switch the rate here if the TV ever becomes a screen for gaming instead.
set -l tv_rate 119.88

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

# An X screen has one vblank source, so with the ultrawide at 165Hz and the TV
# at 60Hz only one of them can be in sync -- picom paces to the primary and the
# TV tears. ForceFullCompositionPipeline hands that output its own composited,
# vblank-locked scanout, which fixes it. (The TV's own Game Mode cannot: it
# only skips the panel's post-processing, and the tear is already in the signal
# by then.)
#
# It is applied per-output rather than to the whole screen because it costs
# about a frame of latency and rules out variable refresh, and the ultrawide
# neither tears nor wants to give up G-Sync.
#
# The token lives in the NVIDIA metamode, not in RandR, and every xrandr call
# builds a fresh metamode -- so this has to run *after* xrandr, every time.
# Rather than restate the geometry (and have it drift from the xrandr calls
# below), it reads back the metamode xrandr just produced and rewrites only the
# composition tokens in it.
#
# It clears the token off every display before setting it on the TV, because
# detaching the TV does not simply drop the token: the driver moves it onto
# whichever display is left. Without the clear, one $mod+p round trip leaves
# the ultrawide permanently composited and G-Sync silently off.
function tearfree -a tv
    command -q nvidia-settings; or return 0

    set -l current (nvidia-settings -q CurrentMetaMode -t 2>/dev/null \
        | string replace -r '^.*? :: ' '')
    test -n "$current"; or return 1
    set -l wanted (string replace -ra ',\s*Force(Full)?CompositionPipeline=On' '' -- $current)

    # Which DPY-n the TV is depends on the driver, so resolve it by connector.
    # [^{] and [^}] keep the match inside that one display's token list. When
    # the TV is detached it has no entry, nothing matches, and the clear stands.
    set -l named (nvidia-settings -q dpys -t 2>/dev/null \
        | string match -r "dpy:(\d+)\]\s+\($tv\)")
    if test (count $named) -ge 2
        set wanted (string replace -r "(DPY-$named[2]: [^{]*\{[^}]*)\}" \
            '$1, ForceFullCompositionPipeline=On}' -- $wanted)
    end

    if test "$wanted" != "$current"
        nvidia-settings --assign CurrentMetaMode="$wanted" >/dev/null 2>&1
    end
    return 0
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
        tearfree $tv
    case off
        xrandr --output $main --primary --mode $main_mode --rate $main_rate \
               --output $tv --off
        tearfree $tv
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

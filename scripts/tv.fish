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

# The rate is chosen at runtime rather than hardcoded, because the TV does not
# serve one EDID -- it alternates between a basic and an extended block (see
# audio-out.fish, which has the same problem from the audio side), and only the
# extended one carries the HDMI Forum descriptor that advertises the high
# refresh rates. Hardcode 119.88 and a boot on the basic block leaves that rate
# off the list entirely, so xrandr fails and the TV never comes up at all.
#
# Of what is on offer, take the fastest rate that both 24 and 30 divide into
# evenly -- so a multiple of 120. This screen mostly plays video, and any other
# rate pulls 24p or 30p down on an uneven cadence and judders: 165Hz is offered
# and trains fine as RGB, but it lands 24p on a 6:7:7:7 cadence. If nothing
# qualifies, fall back to the fastest on offer and accept the pulldown -- on the
# basic block that means 60Hz, which is right for 30p but still 3:2 for 24p.
#
# The rates are NTSC-fractional (119.88 is 120/1.001), so divisibility is
# tested against the rounded nominal rate.
function tv_rates -a output mode
    xrandr --query | awk -v out=$output -v mode=$mode '
        $1 == out && $2 == "connected" { inblock = 1; next }
        # Any unindented line ends the block: the next connector, or the trailer.
        /^[^ \t]/ { inblock = 0 }
        inblock && $1 == mode {
            # Strip the current (*) and preferred (+) markers. xrandr lists the
            # current rate first rather than in order, so this is not sorted.
            for (i = 2; i <= NF; i++) { gsub(/[*+]/, "", $i); print $i }
        }
    '
end

function best_rate -a output mode
    tv_rates $output $mode | awk '
        { nominal = int($1 + 0.5) }
        nominal > fastest { fastest = nominal; fastest_rate = $1 }
        nominal % 24 == 0 && nominal % 30 == 0 && nominal > clean {
            clean = nominal; clean_rate = $1
        }
        END { print (clean ? clean_rate : fastest_rate) }
    '
end

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
        set -l tv_rate (best_rate $tv $tv_mode)
        if test -z "$tv_rate"
            notify-send "TV not usable" "The TV is not offering $tv_mode at any rate."
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

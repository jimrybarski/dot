#!/usr/bin/env fish
#
# Move audio output between the TV and the desk speakers.
#
#   audio-out.fish tv | speakers | toggle (default)
#
# The GPU exposes an audio pin per display but only activates one at a time,
# so pointing at the TV means switching the card profile first -- the sink
# does not exist until then.
#
# Which pin the TV lands on is NOT stable: it has been both the base pin
# (output:hdmi-surround) and the second one (output:hdmi-surround-extra1),
# and the reshuffle silently breaks a hardcoded name, because a pin driving
# the stereo-only ultrawide has no surround profile to switch to at all. So
# the profile is looked up at runtime by the monitor name the pin reports
# over its ELD. To see the current mapping:
#
#   pactl -f json list cards \
#     | jq '.[] | select(.name == "alsa_card.pci-0000_01_00.1") | .ports'
#
# Passthrough is disabled for this card in
# ~/.config/pipewire/media-session.d/alsa-monitor.conf -- see the comment
# there before switching profiles around.

set -l card alsa_card.pci-0000_01_00.1
set -l tv_monitor S90H
set -l gpu_sink_prefix alsa_output.pci-0000_01_00.1.
set -l speakers alsa_output.pci-0000_11_00.6.analog-stereo

# The highest-channel output profile on the pin currently showing the TV, or
# nothing at all when no live pin reports that monitor (TV off or asleep).
function tv_profile -a card monitor
    pactl -f json list cards | jq -r --arg card $card --arg monitor $monitor '
        .[]
        | select(.name == $card)
        | .ports[]
        | select(.availability == "available")
        | select(.properties["device.product.name"] == $monitor)
        | (.properties["audio.channels.detected"] // "2" | tonumber) as $channels
        | .profiles as $profiles
        | [ (if $channels >= 8 then "output:hdmi-surround71" else empty end),
            (if $channels >= 6 then "output:hdmi-surround"   else empty end),
            "output:hdmi-stereo" ]
        | first(.[] as $want
                | $profiles[]
                | select(. == $want or startswith($want + "-extra")))
    '
end

function sinks_matching -a prefix
    pactl -f json list sinks \
        | jq -r --arg prefix $prefix '.[].name | select(startswith($prefix))'
end

function use_sink -a sink
    pactl set-default-sink $sink; or return 1
    # set-default-sink only redirects *new* streams; anything already playing
    # stays put until it is moved by hand.
    for input in (pactl list short sink-inputs | cut -f1)
        pactl move-sink-input $input $sink
    end
end

set -l action $argv[1]
test -z "$action"; and set action toggle

if test "$action" = toggle
    if string match -q "$gpu_sink_prefix*" -- (pactl get-default-sink)
        set action speakers
    else
        set action tv
    end
end

switch $action
    case tv
        set -l profiles (tv_profile $card $tv_monitor)
        if test (count $profiles) -eq 0
            notify-send "No TV audio" "No HDMI pin is reporting $tv_monitor. Is the TV on?"
            exit 1
        end
        pactl set-card-profile $card $profiles[1]; or exit 1
        # the sink takes a moment to appear after the profile switch
        set -l sink
        for i in (seq 20)
            set -l found (sinks_matching $gpu_sink_prefix)
            if test (count $found) -gt 0
                set sink $found[1]
                break
            end
            sleep 0.1
        end
        if test -z "$sink"
            notify-send "No TV audio" "$profiles[1] activated but no sink appeared."
            exit 1
        end
        use_sink $sink
        notify-send "Audio → TV"
    case speakers
        use_sink $speakers
        notify-send "Audio → speakers"
    case '*'
        echo "usage: audio-out.fish [tv|speakers|toggle]" >&2
        exit 2
end

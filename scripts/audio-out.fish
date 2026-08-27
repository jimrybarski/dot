#!/usr/bin/env fish
#
# Move audio output between the TV and the desk speakers.
#
#   audio-out.fish tv | speakers | toggle (default)
#
# The GPU exposes an audio pin per display but only activates one at a time,
# so pointing at the TV means switching the card profile first -- the sink does
# not exist until then. Pin 0 is the DisplayPort ultrawide (no speakers), the
# TV is on the pin behind output:hdmi-surround-extra1. `/proc/asound/card0/eld#0.*`
# names which display sits on which pin if this ever needs rechecking.
#
# Passthrough is disabled for this card in
# ~/.config/pipewire/media-session.d/alsa-monitor.conf -- see the comment there
# before switching profiles around.

set -l card alsa_card.pci-0000_01_00.1
set -l tv_profile output:hdmi-surround-extra1
set -l tv_sink alsa_output.pci-0000_01_00.1.hdmi-surround-extra1
set -l speakers alsa_output.pci-0000_11_00.6.analog-stereo

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
    if string match -q "*hdmi*" -- (pactl get-default-sink)
        set action speakers
    else
        set action tv
    end
end

switch $action
    case tv
        pactl set-card-profile $card $tv_profile
        # the sink takes a moment to appear after the profile switch
        set -l ready 0
        for i in (seq 20)
            if pactl list short sinks | string match -q "*$tv_sink*"
                set ready 1
                break
            end
            sleep 0.1
        end
        if test $ready -eq 0
            notify-send "No TV audio" "The HDMI sink never appeared. Is the TV on?"
            exit 1
        end
        use_sink $tv_sink
        notify-send "Audio → TV"
    case speakers
        use_sink $speakers
        notify-send "Audio → speakers"
    case '*'
        echo "usage: audio-out.fish [tv|speakers|toggle]" >&2
        exit 2
end

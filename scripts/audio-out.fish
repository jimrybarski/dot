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
# Almost nothing about the TV's pin is stable. Which pin it lands on has been
# both the base one (output:hdmi-surround) and the second (output:hdmi-
# surround-extra1), and a reshuffle silently breaks a hardcoded profile because
# a pin driving the stereo-only ultrawide has no surround profile to switch to
# at all.
#
# Worse, the TV does not serve one EDID. It alternates between a basic and an
# extended block depending on what the input has negotiated, and they disagree
# on nearly every field that looks like an identity:
#
#            monitor_name  product_id  size       SADs
#   basic    SAMSUNG       0x77f2      142x80cm   5
#   extended S90H          0x7a6f      144x81cm   6 (+ a second CEA block)
#
# So the name is not an identity and neither is the product id. What has held
# across both is the vendor id and the connection type -- and on this GPU that
# pair is unambiguous anyway, since the only other display is the ultrawide and
# it is on DisplayPort. Everything else is derived at runtime. To see what the
# pins are saying right now:
#
#   grep -H . /proc/asound/card*/eld#*
#   pactl -f json list cards \
#     | jq '.[] | select(.name == "alsa_card.pci-0000_01_00.1") | .ports'
#
# Passthrough is disabled for this card in
# ~/.config/pipewire/media-session.d/alsa-monitor.conf -- see the comment
# there before switching profiles around.

# The GPU's HDMI audio function. Its ALSA card index is handed out at boot and
# is not stable, so it is resolved from this address rather than assumed.
set -l gpu_pci 0000:01:00.1
set -l gpu_slug (string replace -a : _ $gpu_pci)
set -l card alsa_card.pci-$gpu_slug
set -l gpu_sink_prefix alsa_output.pci-$gpu_slug.
# `manufacture_id` (0x2d4c is SAM) and `connection_type`, from the pin's ELD.
set -l tv_vendor 0x2d4c
set -l tv_connection HDMI
set -l speakers alsa_output.pci-0000_11_00.6.analog-stereo

function eld_field -a file key
    string replace -rf "^$key\s+" '' <$file
end

# The ALSA card index for a PCI function, e.g. 0000:01:00.1 -> 0.
function alsa_card_index -a pci
    for dev in /sys/class/sound/card*/device
        if test (basename (realpath $dev)) = $pci
            string replace -r '^.*/card([0-9]+)/device$' '$1' -- $dev
            return 0
        end
    end
    return 1
end

# The name the TV is reporting over its ELD right now -- whichever of its two
# EDIDs it happens to be serving -- or nothing at all when no pin is reading a
# valid ELD from it (TV off, asleep, or on another input). This is the kernel's
# own view and is true the instant the TV wakes up, which is why it -- and not
# PipeWire's port list -- decides whether the TV is there. The name is only
# ever used as a join key into PipeWire, never as an identity.
function tv_eld_name -a index vendor connection
    for eld in /proc/asound/card$index/eld#*
        set -l valid (eld_field $eld eld_valid)
        set -l seen_vendor (eld_field $eld manufacture_id)
        set -l seen_connection (eld_field $eld connection_type)
        test "$valid" = 1 -a "$seen_vendor" = "$vendor" -a "$seen_connection" = "$connection"
        or continue
        eld_field $eld monitor_name
        return 0
    end
    return 1
end

# Every pin currently reading an EDID, for the failure notification. Without
# this, an identity that has drifted again looks exactly like a TV that is off.
function live_pins -a index
    for eld in /proc/asound/card$index/eld#*
        set -l valid (eld_field $eld eld_valid)
        test "$valid" = 1; or continue
        set -l name (eld_field $eld monitor_name)
        set -l vendor (eld_field $eld manufacture_id)
        set -l connection (eld_field $eld connection_type)
        echo "$name ($vendor, $connection)"
    end
end

# The highest-channel output profile on the pin showing $monitor, or nothing
# when PipeWire is not offering that pin (yet).
function tv_profile -a card monitor
    pactl -f json list cards | jq -r --arg card $card --arg monitor $monitor '
        .[]
        | select(.name == $card)
        | .ports[]
        | select(.availability != "not available")
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
        set -l index (alsa_card_index $gpu_pci)
        if test -z "$index"
            notify-send "No TV audio" "No ALSA card at PCI $gpu_pci."
            exit 1
        end
        set -l monitor (tv_eld_name $index $tv_vendor $tv_connection)
        if test -z "$monitor"
            set -l seen (live_pins $index)
            if test (count $seen) -eq 0
                notify-send "No TV audio" "No pin on this card is reading an EDID. Is the TV on and showing this input?"
            else
                notify-send "No TV audio" "No $tv_vendor pin on $tv_connection. Live pins: "(string join '; ' $seen)
            end
            exit 1
        end
        # The TV may have only just been switched on -- the kernel has the new
        # ELD the moment it handshakes, but PipeWire takes a beat to notice the
        # pin went live and republish the card. Only wait once the ELD has
        # confirmed the TV is actually there, so a TV that is off still fails
        # immediately rather than hanging for two seconds first.
        set -l profiles
        for i in (seq 20)
            set profiles (tv_profile $card $monitor)
            test (count $profiles) -gt 0; and break
            sleep 0.1
        end
        if test (count $profiles) -eq 0
            notify-send "No TV audio" "The TV is reporting as \"$monitor\" but PipeWire has no pin for it."
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

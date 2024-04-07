#!/usr/bin/env bash

# Check if gaps are supported
gaps_support=$(i3 --version | grep -o "gaps")

# If gaps are supported, enable them
if [[ -n "$gaps_support" ]]; then
    cat <<EOF
    gaps inner 8px
    gaps outer 0px
    EOF
fi

#!/usr/bin/env bash

DIR="$1"  # left | right

# Fixed physical order
MONS=("DP-1" "HDMI-A-1" "eDP-1")

FOCUSED=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

# Find focused index
for i in "${!MONS[@]}"; do
    [[ "${MONS[$i]}" == "$FOCUSED" ]] && IDX="$i"
done

[[ -z "$IDX" ]] && exit 0

if [[ "$DIR" == "left" ]]; then
    [[ "$IDX" -eq 0 ]] && exit 0
    TARGET="${MONS[$((IDX-1))]}"
elif [[ "$DIR" == "right" ]]; then
    [[ "$IDX" -eq $((${#MONS[@]}-1)) ]] && exit 0
    TARGET="${MONS[$((IDX+1))]}"
else
    exit 1
fi

# Collect workspaces
WS_FOCUSED=$(hyprctl workspaces -j | jq -r --arg m "$FOCUSED" '.[] | select(.monitor==$m) | .id')
WS_TARGET=$(hyprctl workspaces -j | jq -r --arg m "$TARGET" '.[] | select(.monitor==$m) | .id')

# Move target first (important!)
for ws in $WS_TARGET; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$FOCUSED"
done

# Move focused to target
for ws in $WS_FOCUSED; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$TARGET"
done



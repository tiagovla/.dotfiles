#!/bin/sh

mod() {
    n=$1
    size=$2
    result=$((n % size))
    [ $result -lt 0 ] && result=$((result + size))
    echo $result
}

find_index() {
    target=$1
    shift
    array="$@"
    index=0
    for element in $array; do
        if [ "$element" = "$target" ]; then
            echo $index
            return 0
        fi
        index=$((index + 1))
    done
    echo -1
    return 1
}

# Get monitors (IDs and names)
monitor_ids=($(hyprctl monitors -j | jq -r '.[].id'))
monitor_names=($(hyprctl monitors -j | jq -r '.[].name'))

# Current monitor ID
current_monitor_id=$(hyprctl activeworkspace -j | jq -r '.monitorID')

index=$(find_index "$current_monitor_id" "${monitor_ids[@]}")
next_index=$(mod $((index + 1)) ${#monitor_ids[@]})
previous_index=$(mod $((index - 1)) ${#monitor_ids[@]})

next_monitor_id=${monitor_ids[$next_index]}
previous_monitor_id=${monitor_ids[$previous_index]}

# Current workspace info
current_ws=$(hyprctl activeworkspace -j | jq -r '.name')

# Focused workspace on other monitors
prev_ws=$(hyprctl workspaces -j | jq -r ".[] | select(.monitorID==$previous_monitor_id and .focused==true) | .name")
next_ws=$(hyprctl workspaces -j | jq -r ".[] | select(.monitorID==$next_monitor_id and .focused==true) | .name")

case "$1" in
    --rotate-reverse)
        # Move current workspace to next monitor and swap names
        hyprctl dispatch moveworkspacetomonitor "$current_ws" "$next_monitor_id"
        [ -n "$next_ws" ] && hyprctl dispatch renameworkspace "$current_ws" "$next_ws"
        hyprctl dispatch focusmonitor "$next_monitor_id"
        hyprctl dispatch workspace "$current_ws"
        ;;
    --rotate)
        hyprctl dispatch moveworkspacetomonitor "$current_ws" "$previous_monitor_id"
        [ -n "$prev_ws" ] && hyprctl dispatch renameworkspace "$current_ws" "$prev_ws"
        hyprctl dispatch focusmonitor "$previous_monitor_id"
        hyprctl dispatch workspace "$current_ws"
        ;;
    *)
        echo "Usage: $0 --rotate|--rotate-reverse" >&2
        exit 1
        ;;
esac


#! /bin/sh

bus_name="org.mpris.MediaPlayer2.spotify"
object_path="/org/mpris/MediaPlayer2"
domain="org.mpris.MediaPlayer2"
interface="org.mpris.MediaPlayer2.Player"

function join_by {
    local d=${1-} f=${2-}
    if shift 2; then
        printf %s "$f" "${@/#/$d}"
    fi
}

info() {
    if ! pgrep -x spotify >/dev/null; then
        echo ""
        exit
    fi

    meta=$(dbus-send --print-reply \
        --dest=${bus_name} \
        ${object_path} \
        org.freedesktop.DBus.Properties.Get \
        string:${interface} string:Metadata 2>&-)

    artist=$(echo "$meta" | sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' | sed -n 2p)
    album=$(echo "$meta" | sed -nr '/xesam:album"/,+1s/^ +variant +string "(.*)"$/\1/p')
    title=$(echo "$meta" | sed -nr '/xesam:title"/,+1s/^ +variant +string "(.*)"$/\1/p')

    format=()
    if [ -n "$artist" ]; then
        format+=("${artist}")
    fi
    format+=("$title")
    echo $(join_by ' - ' "${format[@]}")
}

toggle() {
    dbus-send --print-reply \
        --dest=${bus_name} \
        ${object_path} \
        "${interface}.PlayPause" >/dev/null
}

previous() {
    dbus-send --print-reply \
        --dest=${bus_name} \
        ${object_path} \
        "${interface}.Previous" >/dev/null
}

previous() {
    dbus-send --print-reply \
        --dest=${bus_name} \
        ${object_path} \
        "${interface}.Previous" >/dev/null
}

next() {
    dbus-send --print-reply \
        --dest=${bus_name} \
        ${object_path} \
        "${interface}.Next" >/dev/null
}

if [ "$1" == "-h" -o "$1" == "--help" ]; then
    echo "Parameters: --info --toggle --next --prev"
elif [ $# -eq 0 -o "$1" == "--info" ]; then
    info
else
    case $1 in
    "--toggle")
        toggle
        ;;
    "--next")
        next
        ;;
    "--prev")
        previous
        ;;
    *)
        echo >&2 "Invalid parameter, check --help." &
        exit 1
        ;;
    esac
fi
exit 0

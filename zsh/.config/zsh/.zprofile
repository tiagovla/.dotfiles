if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    echo "Starting Hyprland..."
    [[ $(fgconsole 2>/dev/null) == 1 ]] && exec start-hyprland &> /dev/null
fi

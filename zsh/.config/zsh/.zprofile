if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    echo "Starting X..."
    [[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 -keeptty -ardelay 200 -arinterval 120 vt1 &> /dev/null
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
    echo "Starting Hyprland..."
    [[ $(fgconsole 2>/dev/null) == 2 ]] && exec hyprland &> /dev/null
fi

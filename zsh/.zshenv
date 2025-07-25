export ZDOTDIR="$HOME/.config/zsh"
export GTK_IM_MODULE=cedilla
export QT_IM_MODULE=cedilla 
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
# export __NV_PRIME_RENDER_OFFLOAD=1
# export __GLX_VENDOR_LIBRARY_NAM="nvidia"
# export __VK_LAYER_NV_optimus="NVIDIA_only"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    echo "Starting X..."
    [[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 -keeptty -ardelay 200 -arinterval 120 vt1 &> /dev/null
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
    echo "Starting Hyprland..."
    [[ $(fgconsole 2>/dev/null) == 2 ]] && exec hyprland &> /dev/null
fi


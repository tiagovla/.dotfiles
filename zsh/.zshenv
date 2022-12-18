export ZDOTDIR="$HOME/.config/zsh"
export GTK_IM_MODULE=cedilla
export QT_IM_MODULE=cedilla 

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    [[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null
fi


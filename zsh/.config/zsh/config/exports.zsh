#! /bin/bash

export LANG=en_US.UTF-8
export EDITOR='nvim'
export TERMINAL="alacritty"
export BROWSER="brave"
export PYENV_ROOT="$HOME/.pyenv"

# PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/usr/local/Polyspace/R2021a/bin:$PATH"
export PATH="/opt/ParaView-5.9.1-MPI-Linux-Python3.8-64bit/bin:$PATH"

# tools
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(zoxide init --cmd c zsh)"
"$HOME/scripts/kbd_layout.sh"

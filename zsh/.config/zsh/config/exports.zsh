#!/bin/zsh
export _JAVA_AWT_WM_NONREPARENTING=1

export GDK_DPI_SCALE=1.5
export GDK_SCALE=1.5

export LANG=en_US.UTF-8
export EDITOR='nvim'
export TERMINAL="wezterm"
export BROWSER="brave"
export GTK_THEME=Adwaita:dark
export GTEST_COLOR=1
export PDFVIEWER=zathura

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/opt/cuda/bin:$PATH"
# export PATH="$HOME/.asdf/shims:$PATH"

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export PYTHON_KEYRING_BACKEND=keyring.backends.fail.Keyring
export NVCC_PREPEND_FLAGS='-ccbin /opt/cuda/bin'

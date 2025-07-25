#!/bin/zsh

# locale & environment
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export TERMINAL="wezterm"
export BROWSER="chrome"
export PDFVIEWER="zathura"
export GTK_THEME="Adwaita:dark"
export GTEST_COLOR=1

# display settings
export _JAVA_AWT_WM_NONREPARENTING=1
export GDK_SCALE=1.5
export GDK_DPI_SCALE=1.5
export QT_SCALE_FACTOR=1.5
export QT_SCREEN_SCALE_FACTORS=1.5
export GTK_IM_MODULE=cedilla
export QT_IM_MODULE=cedilla 
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAM="nvidia"
export __VK_LAYER_NV_optimus="NVIDIA_only"

# path setup
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$PATH:/opt/cuda/bin"

# xdg base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# python & cuda config
export PYTHON_KEYRING_BACKEND="keyring.backends.fail.Keyring"
export NVCC_PREPEND_FLAGS="-ccbin /opt/cuda/bin"

# ssh agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

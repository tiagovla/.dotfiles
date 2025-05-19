#!/bin/zsh
#
export KEYTIMEOUT=1
bindkey -v '^?' backward-delete-char
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

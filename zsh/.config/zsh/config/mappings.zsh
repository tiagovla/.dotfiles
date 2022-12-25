#!/bin/zsh
#
export KEYTIMEOUT=1
bindkey -v
bindkey -v '^?' backward-delete-char
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

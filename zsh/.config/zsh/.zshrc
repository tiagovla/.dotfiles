#!/bin/bash

for zfile in prompt functions settings aliases plugins mappings; do
    source "$ZDOTDIR/config/${zfile}.zsh"
done

zsh-defer source "$ZDOTDIR/config/secrets.zsh"

autoload -Uz compinit
setopt EXTENDEDGLOB
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh2) ]]; then
  compinit
else
  compinit -C
fi

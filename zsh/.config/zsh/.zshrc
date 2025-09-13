#!/bin/bash

for zfile in prompt functions settings aliases plugins mappings; do
    source "$ZDOTDIR/config/${zfile}.zsh"
done

for zfile in secrets; do
    zsh-defer source "$ZDOTDIR/config/${zfile}.zsh"
done

autoload -Uz compinit
setopt EXTENDEDGLOB
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh2) ]]; then
  compinit
else
  compinit -C
fi

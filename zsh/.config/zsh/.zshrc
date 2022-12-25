#!/bin/bash
zmodload zsh/zprof
for zfile in exports functions prompt settings aliases plugins mappings; do
# shellcheck disable=SC1090
    source "$ZDOTDIR/config/${zfile}.zsh"
done

autoload -Uz compinit
setopt EXTENDEDGLOB
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh2) ]]; then
  compinit
else
  compinit -C
fi

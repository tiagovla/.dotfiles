#!/bin/bash
zmodload zsh/zprof
for zfile in exports functions prompt settings aliases plugins mappings secrets; do
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

# export all_proxy="socks5://192.0.0.4:1080"
eval "$(zoxide init --cmd c zsh)"

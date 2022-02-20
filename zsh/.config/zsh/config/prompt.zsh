#!/bin/zsh

autoload -Uz vcs_info

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

PROMPT="%(?.%B%F{green}√.%F{red}√)%f%b "
PROMPT+="%B%F{cyan}%c%f%b "
PROMPT+="\$vcs_info_msg_0_ " 
RPROMPT="%(?.%B%F{green} .%F{red}[%?])%f%b "

zstyle ':vcs_info:git:*' formats '%F{blue}git:(%f%F{red}%b%f%F{blue})%f'
zstyle ':vcs_info:*' enable git


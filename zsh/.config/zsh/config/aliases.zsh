#! /bin/bash
alias pacman='sudo pacman'
alias 9gag='f(){ youtube-dl "$@" --recode-video webm || exit 1;  unset -f f; }; f'
alias :q='exit'
declare BUILD_DIR=$(BUILD)
declare INSTALL_DIR=$(INSTALL)
alias cmakehere='cmake -B $BUILD_DIR --install-prefix=$INSTALL_DIR'

alias qq='clear'
alias Q='exit'
# alias sudo='doas'
alias la='ls -a --color=auto'
alias ll='ls -la --color=auto'
alias ls='exa --icons --color=auto --time-style=long-iso --group-directories-first --git'
alias du='du --max-depth=1 --si'
alias rm='trash'
alias df='df --all --si --print-type'
alias mkdir='mkdir --parents'
alias grep="grep --color='auto'"
alias ncdu="ncdu --color=off"
alias rc="rclone"
alias cf='cd $(/bin/fd -d 2 --type directory | fzf --layout=reverse --height=10)'

alias cp='cp --interactive --verbose'
alias ln='ln --interactive --verbose'
alias mv='mv --interactive --verbose'

alias ranger='alacritty --class Ranger -e /usr/bin/ranger'
alias n='nvim'
alias l='la'
alias -s pdf="zathura"
eval "$(zoxide init --cmd c zsh)"

alias xcopy='xclip -selection clipboard -in'
alias clip='xclip -selection clipboard -in'
alias mixer='ncpamixer'

alias g='git'

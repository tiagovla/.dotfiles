#!/bin/zsh
alias pacman='sudo pacman'
alias ytd_discord='f(){ yt-dlp "$@" --recode-video webm || exit 1;  unset -f f; }; f'
alias :q='exit'
alias qq='clear'
alias Q='exit'
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
alias cf='cd "$(/bin/fd -d 2 --type directory | fzf --layout=reverse --height=10)"'

alias cp='cp --interactive --verbose'
alias ln='ln --interactive --verbose'
alias mv='mv --interactive --verbose'

alias ranger='alacritty --class Ranger -e /usr/bin/ranger'
alias n='nvim'
alias l='la'
alias -s pdf="zathura"

alias xcopy='xclip -selection clipboard -in'
alias clip='xclip -selection clipboard -in'
alias mixer='ncpamixer'

alias g='git'
function gs() {
    git status -s -b "${@}" && git ql 2>/dev/null
}
function gc() {
    git commit -v "${@}"
}
function g.() {
    git add -p "${@}"
}
function gd() {
    git diff "${@}"
}
function gp() {
    git checkout -p "${@}"
}
function gr() {
    git rebase "${@}"
}
function grc() {
    git rebase --continue "${@}"
}
function gar() {
    git add --all .
}
function ga() {
    git commit --amend --reuse-message=HEAD
}

#!/bin/zsh

# system & package manager
alias pacman='sudo pacman'
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias mixer='ncpamixer'

# filesystem & navigation
alias ls='exa --icons --color=auto --time-style=long-iso --group-directories-first --git'
alias la='ls -a --color=auto'
alias ll='ls -la --color=auto'
alias l='la'
alias du='dust'
alias df='df --all --si --print-type'
alias mkdir='mkdir --parents'
# alias rm='trash'
alias cp='cp --interactive --verbose'
alias mv='mv --interactive --verbose'
alias ln='ln --interactive --verbose'
alias cat='bat -Pp'
alias grep="grep --color='auto'"
alias ncdu='ncdu --color=off'

#text clipboard / qr / files
alias xcopy='xclip -selection clipboard -in'
alias clip='xclip -selection clipboard -in'
alias qr='qrencode -t ansiutf8'

# terminal utils / tools
alias :q='exit'
alias Q='exit'
alias rc='rclone'
alias ranger='alacritty --class Ranger -e /usr/bin/ranger'

# python / poetry / devtools
alias ppy='poetry run python'
alias g='git'

# docker aliases
alias dr='docker run --rm -it'
alias dc='docker compose'

# fuzzy navigation
alias cf='cd "$(/bin/fd -d 2 --type directory | fzf --layout=reverse --height=10)"'

# media / youtube
alias ytd_discord='f(){ yt-dlp "$@" --recode-video webm || exit 1; unset -f f; }; f'

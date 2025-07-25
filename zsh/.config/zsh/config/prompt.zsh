#!/bin/zsh

setopt prompt_subst

function prompt-length() {
    emulate -L zsh
    local -i COLUMNS=${2:-COLUMNS}
    local -i x y=${#1} m
    if (( y )); then
        while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
            x=y
            (( y *= 2 ))
        done
        while (( y > x + 1 )); do
            (( m = x + (y - x) / 2 ))
            (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
        done
    fi
    typeset -g REPLY=$x
}

function fill-line() {
    emulate -L zsh
    prompt-length $1
    local -i left_len=REPLY
    prompt-length $2 9999
    local -i right_len=REPLY
    local -i pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1}))
    if (( pad_len < 1 )); then
        typeset -g REPLY=$1
    else
        local pad=${(pl.$pad_len.. .)}
        typeset -g REPLY=${1}${pad}${2}
    fi
}
setopt transientrprompt

function preexec() {
    timer=${timer:-$SECONDS}
}

function set-prompt() {
    emulate -L zsh
    local git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    local top_left="", top_right="", bottom_left="", bottom_right=""
    git_branch=${git_branch//\%/%%}
    top_left="%B%F{cyan}%~%f%b "
    if [ $git_branch ]; then
        top_left+="%F{blue}git:(%f%F{red}${git_branch}%f%F{blue})%f"
    fi
    top_right='%F{yellow}%T%f'
    bottom_left='%B%F{%(?.green.red)}√%f%b '
    bottom_right="%(?.%B%F{green} .%F{red}[%?])%f"
    if [ $timer ]; then
        timer_show=$(($SECONDS - $timer))
        timer_show=$(printf '%.*f\n' 0 $timer_show)
        if [ ! -a $timer_show != "0" ]; then
            top_right="%b%F{blue}[${timer_show}s]%F{blue}"
        fi
        unset timer
    fi
    local REPLY
    fill-line "$top_left" "$top_right"
    PROMPT=$REPLY$'\n'$bottom_left
    RPROMPT=$bottom_right
}

setopt no_prompt_{bang,subst} prompt_{cr,percent,sp}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set-prompt

#source: https://gist.github.com/romkatv/2a107ef9314f0d5f76563725b42f7cab

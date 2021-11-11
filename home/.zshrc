#! /bin/zsh

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=7

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
plugins=(git vi-mode zsh-autosuggestions sudo web-search copydir copyfile history)

source $ZSH/oh-my-zsh.sh

## share clipboard pasting using on zsh
function x11-clip-wrap-widgets() {
	local copy_or_paste=$1
	shift
	for widget in "$@"; do
		if [[ $copy_or_paste == "copy" ]]; then
			eval "function _x11-clip-wrapped-$widget() { zle .$widget xclip -in -selection clipboard <<<\$CUTBUFFER }"
		else
			eval "function _x11-clip-wrapped-$widget() { CUTBUFFER=\$(xclip -out -selection clipboard) zle .$widget }"
		fi
		zle -N $widget _x11-clip-wrapped-$widget
	done
}
local copy_widgets=(vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line)
local paste_widgets=(vi-put-{before,after})
x11-clip-wrap-widgets copy $copy_widgets
x11-clip-wrap-widgets paste $paste_widgets

## CONFIG
export LANG=en_US.UTF-8
export EDITOR='nvim'

alias zshconfig="${EDITOR} ~/.zshrc"
alias clone="git clone"

# EXPORTS
export PYENV_ROOT="$HOME/.pyenv"
export PETSC_ARCH=arch-linux-c-debug

## PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/usr/local/Polyspace/R2021a/bin:$PATH"
export PATH="/opt/ParaView-5.9.1-MPI-Linux-Python3.8-64bit/bin:$PATH"

## ALIASES
alias nvimp='f(){ poetry run nvim "$@" || nvim;  unset -f f; }; f'
alias 9gag='f(){ youtube-dl "$@" --recode-video webm || exit 1;  unset -f f; }; f'
alias fixfan="sudo ${HOME}/scripts/fan_speed.sh"
alias ls='ls --color=auto'
alias tvm='mpv --ytdl-format=93 $1'
#SETTING UP PYENV
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(zoxide init --cmd c zsh)"

$HOME/scripts/kbd_layout.sh
# bindkey -v

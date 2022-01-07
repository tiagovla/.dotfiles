#! /bin/bash
alias pacman='sudo pacman'

alias 9gag='f(){ youtube-dl "$@" --recode-video webm || exit 1;  unset -f f; }; f'
alias fixfan="sudo ${HOME}/scripts/fan_speed.sh"

alias la='ls -a --color=auto'
alias ll='ls -la --color=auto'
alias ls='ls --color=auto'

alias du='du --max-depth=1 --si'
alias rm='trash'
alias df='df --all --si --print-type'
alias mkdir='mkdir --parents'
alias grep="grep --color='auto'"
alias book="zathura ${HOME}/github/nonlinear/book.pdf"

alias cp='cp --interactive --verbose'
alias ln='ln --interactive --verbose'
alias mv='mv --interactive --verbose'
alias cd='c'

alias ranger='alacritty --class Ranger -e /usr/bin/ranger'

alias n='nvim'
alias g='git'

alias -s pdf="zathura"
eval "$(thefuck --alias)"

transfer() {
	filename=$(basename "$1")
	res=$(
		curl --progress-bar --upload-file "$1" https://transfer.sh/${filename// /_}
	)
	echo "${res/.sh/.sh/get}" | xclip -selection clipboard -in
	printf "%s\n" "${res/.sh/.sh/get}"

	# echo $res
	# echo $res
}

alias transfer=transfer

#!/bin/sh
set -eu

mode=$1

case $mode in
attach-directory)
	exec tmux new-session -A -s "$2"
	;;
attach-global)
	exec tmux new-session -A -s popup
	;;
directory|global)
	pane=$2
	client=$3
	;;
*)
	printf 'unknown popup mode: %s\n' "$mode" >&2
	exit 2
	;;
esac

format() {
	# Keep path-ending newlines while stripping display-message's added newline.
	output=$(tmux display-message -p -t "$pane" "$1" || return; printf '.')
	output=${output%.}
	value=${output%?}
}

case $mode in
directory)
	format '#{pane_current_path}'
	directory=$value
	format '#{session_name}'
	case $value in
		p-*|popup-dir-*) exec tmux detach-client -t "$client" ;;
	esac
	name=$(printf '%s' "$directory" | sha256sum | cut -c1-8)
	name="p-$name"
	exec tmux display-popup -c "$client" -t "$pane" -d '#{pane_current_path}' -xC -yC -w 80% -h 75% -E "$0" attach-directory "$name"
	;;
global)
	format '#{session_name}'
	if [ "$value" = popup ] || [ "$value" = popup-global ]; then
		exec tmux detach-client -t "$client"
	fi
	exec tmux display-popup -c "$client" -t "$pane" -xC -yC -w 80% -h 75% -E "$0" attach-global
	;;
esac

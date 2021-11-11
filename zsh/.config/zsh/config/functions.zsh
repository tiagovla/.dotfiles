#! /bin/zsh

function zsh_add_file() {
	[ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

function zsh_add_plugin() {
	PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
	if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
		zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" ||
			zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
	else
		git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
	fi
}

function zsh_add_completion() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
		completion_file_path=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
		fpath+="$(dirname "${completion_file_path}")"
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
		fpath+=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
        [ -f $ZDOTDIR/.zccompdump ] && $ZDOTDIR/.zccompdump
    fi
	completion_file="$(basename "${completion_file_path}")"
	if [ "$2" = true ] && compinit "${completion_file:1}"
}

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
x11-clip-wrap-widgets copy $copy_widgets
x11-clip-wrap-widgets paste $paste_widgets

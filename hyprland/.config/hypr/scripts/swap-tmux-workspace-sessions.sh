#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 SOURCE_WORKSPACE_NAME TARGET_WORKSPACE_NAME" >&2
    exit 2
fi
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Workspace names must not be empty" >&2
    exit 2
fi

source_session=$(tmux display-message -p -t "=$1:" '#{session_id}' 2>/dev/null) || source_session=
target_session=$(tmux display-message -p -t "=$2:" '#{session_id}' 2>/dev/null) || target_session=

if [ -n "$source_session" ] && [ -n "$target_session" ]; then
    # Stable session IDs let both names swap without detaching clients or losing panes.
    tmux rename-session -t "$source_session" "hypr-rotate-$$"
    trap 'tmux rename-session -t "$target_session" "$2" || :; tmux rename-session -t "$source_session" "$1" || :' EXIT
    tmux rename-session -t "$target_session" "$1"
    tmux rename-session -t "$source_session" "$2"
    trap - EXIT
elif [ -n "$source_session" ]; then
    tmux rename-session -t "$source_session" "$2"
elif [ -n "$target_session" ]; then
    tmux rename-session -t "$target_session" "$1"
fi

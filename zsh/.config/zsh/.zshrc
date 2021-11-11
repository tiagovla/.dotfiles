#!/bin/bash
for zfile in exports functions prompt settings aliases plugins mappings; do
	# shellcheck disable=SC1090
	source "$ZDOTDIR/config/${zfile}.zsh"
done

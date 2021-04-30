#!/bin/bash

TMP_DIR=$(mktemp -d)
if [ ! -e "$TMP_DIR" ]; then
	echo >&2 "Failed to create temp directory."
	exit 1
fi
trap "exit 1" HUP INT PIPE QUIT TERM
trap 'rm -rf "$TMP_DIR"' EXIT
echo "Created temporary directory $TMP_DIR."

NEOVIM_TMP_DIR="$TMP_DIR/neovim"

if uname -a | grep -q Ubuntu; then
	echo "Installing dependencies on ubuntu..."
	sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
elif [ -f "/etc/arch-release" ]; then
	echo "Installing dependencies on arch..."
	sudo pacman -S base-devel cmake unzip ninja tree-sitter
fi

git clone https://github.com/neovim/neovim.git "$NEOVIM_TMP_DIR"
cd "$NEOVIM_TMP_DIR" || exit 1
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd - >/dev/null || exit 1

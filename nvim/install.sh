#!/bin/bash

TMPDIR=$(mktemp -d)
if [ ! -e "$TMPDIR" ]; then
	echo >&2 "Failed to create temp directory."
	exit 1
fi
trap "exit 1" HUP INT PIPE QUIT TERM
trap 'rm -rf "$TMPDIR"' EXIT
echo "Created temporary directory $TMPDIR."

DOTFILES_TMP_DIR="$TMPDIR/dotfiles"
HOME_CONFIG_DIR="$HOME/.config"
HOME_CONFIG_NVIM_DIR="${HOME_CONFIG_DIR}/nvim"

clone_dotfiles() {
	echo "Cloning dotfiles..."
	git clone \
		--depth 1 \
		--filter=blob:none \
		--no-checkout \
		https://github.com/tiagovla/dotfiles.git \
		"$DOTFILES_TMP_DIR" \
		;
	cd "$DOTFILES_TMP_DIR" || exit
	git sparse-checkout init --cone
	git sparse-checkout set nvim
	git checkout master
	cd - >/dev/null || exit
}

backup_nvim() {
	TIMENOW=$(date +"%s")
	BACKUP_PATH="${HOME_CONFIG_NVIM_DIR}_${TIMENOW}_bk"
	mv "$HOME_CONFIG_NVIM_DIR" "$BACKUP_PATH" || exit
	echo "Your old neovim configuration $HOME_CONFIG_NVIM_DIR was moved to $BACKUP_PATH."
}

copy_nvim() {
	if [ -d "$HOME_CONFIG_NVIM_DIR" ]; then
		echo "Nvim config backup failed."
		exit
	else
		echo "New configuration copied to ${HOME_CONFIG_NVIM_DIR}."
		cp -r "$DOTFILES_TMP_DIR/nvim" "$HOME_CONFIG_NVIM_DIR"
	fi
}

install_packer() {
	git clone \
		"https://github.com/wbthomason/packer.nvim" \
		"$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" \
		;
}

## Installation:

#clone dotfiles from github
clone_dotfiles
#check if there is an old config
[ -d "$HOME_CONFIG_NVIM_DIR" ] && backup_nvim
#copy new configuration
copy_nvim

if [ -a "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
	echo 'Packer already installed.'
else
	install_packer
fi

nvim -u "$HOME_CONFIG_NVIM_DIR/init.lua" "+PackerInstall"

# nvim_path=$(
# 	cd "$(dirname "${BASH_SOURCE[0]}")" || exit
# 	pwd -P
# )
# cd "$nvim_path" || exit
# echo "$nvim_path"

# function install_bash_ls() {
# 	sudo apt install shellcheck
# 	GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
# }

# function install_go() {
# wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
# rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
# rm go1.16.2.linux-amd64.tar.gz
# }

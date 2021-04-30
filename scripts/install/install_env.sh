#!/bin/bash

if uname -a | grep -q Ubuntu; then
	echo "Installing dependencies on ubuntu..."
	sudo apt-get install zsh golang-go \
		make build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

elif [ -f "/etc/arch-release" ]; then
	echo "Installing dependencies on arch..."
	sudo pacman -S zsh go
fi

# update tmux config
curl https://raw.githubusercontent.com/tiagovla/dotfiles/master/.tmux.conf >"$HOME/.tmux.conf"

# update bash config
curl https://raw.githubusercontent.com/tiagovla/dotfiles/master/.bashrc >"$HOME/.bashrc"
source "$HOME/.bashrc"

# pyenv
if ! command -v pyenv &>/dev/null; then
	rm "$HOME/.pyenv" -rf
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	pyenv install 3.9.4
	pyenv install 2.7.18
	pyenv global 3.9.4 2.7.18
fi

# poetry
if ! command -v poetry &>/dev/null; then
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
fi

# zsh
if ! command -v zsh &>/dev/null; then
	# install ohmyzsh
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	# update zsh config
	curl https://raw.githubusercontent.com/tiagovla/dotfiles/master/.zshrc >"$HOME/.zshrc"
	source "$HOME/.zshrc"
fi

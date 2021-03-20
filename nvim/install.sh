#!/bin/bash
nvim_path=$(
	cd "$(dirname "${BASH_SOURCE[0]}")" || exit
	pwd -P
)
cd "$nvim_path" || exit
echo "$nvim_path"

function install_bash_ls() {
	sudo apt install shellcheck
	GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
}

function install_go() {
	wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
	rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
    rm go1.16.2.linux-amd64.tar.gz
}

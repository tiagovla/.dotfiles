#! /bin/sh
nvim --headless +'autocmd User PackerComplete sleep 100m | qall' +PackerSync
nvim --headless +'TSInstallSync maintained' +'q'

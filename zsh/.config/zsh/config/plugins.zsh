#!/bin/zsh

source "$ZDOTDIR/config/functions.zsh"

zsh_add_plugin "romkatv/zsh-defer"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "Valiev/almostontop"
zsh_add_plugin "Aloxaf/fzf-tab"
zsh_add_plugin "MichaelAquilina/zsh-you-should-use"

# zsh_add_plugin "marlonrichert/zsh-autocomplete"
# zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
# zsh_add_plugin "hlissner/zsh-autopair"

if [[ ! -v VIRTUAL_ENV ]]; then
    eval "$(mise activate zsh)"
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd c zsh)"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f7f7f'

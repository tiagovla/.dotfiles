#!/bin/zsh

cache="$XDG_RUNTIME_DIR/pass-env"
store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

if [[ ! -f "$cache" ]]; then
  umask 077

  for file in "$store"/env/*.gpg(N); do
    var="${file:t:r}"
    printf '%s=%s\n' "$var" "$(pass show "env/$var")"
  done > "$cache"
fi

while IFS='=' read -r key value; do
  export "$key=$value"
done < "$cache"

#!/bin/zsh

cache="$XDG_RUNTIME_DIR/pass-env"
store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

if [[ ! -f "$cache" ]]; then
  (
    umask 077
    flock -x 9 || exit 1
    [[ -f "$cache" ]] && exit 0

    # Publish only a complete cache; shells can start during background preloading.
    temp=$(mktemp "$cache.XXXXXX") || exit 1
    trap 'rm -f -- "$temp"' EXIT

    for file in "$store"/env/*.gpg(N); do
      var="${file:t:r}"
      value=$(pass show "env/$var") || exit 1
      printf '%s=%s\n' "$var" "$value"
    done > "$temp" || exit 1
    mv -- "$temp" "$cache"
  ) 9>"$cache.lock" || return 1
fi

while IFS='=' read -r key value; do
  export "$key=$value"
done < "$cache"

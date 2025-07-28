#!/bin/zsh

for var in BOT_TOKEN TWITCH_CLIENT_ID TWITCH_CLIENT_SECRET OPENAI_API_KEY TOGGL_API_TOKEN; do
  export "$var"="$(pass show "env/$var")"
done

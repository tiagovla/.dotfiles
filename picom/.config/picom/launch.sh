#!/usr/bin/env bash

killall -q picom
echo "---" | tee -a /tmp/picom.log
picom --backend glx 2>&1 | tee -a /tmp/picom.log &
disown
echo "Picom launched..."

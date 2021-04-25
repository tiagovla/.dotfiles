#!/usr/bin/env bash

killall -q polybar && sleep 2

echo "---" | tee -a /tmp/polybar1.log

polybar tokyodark 2>&1 | tee -a /tmp/polybar1.log & disown

echo "Bars launched..."

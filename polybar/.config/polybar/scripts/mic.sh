#!/bin/bash

if [[ $(pacmd info | grep "source output" | cut -d " " -f1) -gt 0 ]]; then
    if ! amixer get Capture | grep -q "off"; then
        echo On
    else
        echo Off
    fi
fi

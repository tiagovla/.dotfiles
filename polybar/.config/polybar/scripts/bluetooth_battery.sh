#!/bin/sh

bluetooth_print() {
    if [ "$(systemctl is-active "bluetooth.service")" = "active" ]; then
        devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
        for device in $devices_paired; do
            device_info=$(bluetoothctl info "$device")
            if echo "$device_info" | grep -q "Connected: yes"; then
                echo "$device_info" | grep Battery | cut -d ' ' -f 4- | tr -d '()'
            fi
        done
    fi
}

case "$1" in
--toggle) ;; #TODO: implement toggling
*)
    bluetooth_print
    ;;
esac

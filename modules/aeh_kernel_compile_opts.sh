#!/bin/bash

aeh_options=(
  "CONFIG_BUG"
  "CONFIG_PANIC_ON_OOPS"
  "CONFIG_PANIC_TIMEOUT"
)

kernel_config="/boot/config-$(uname -r)"

function evaluate() {
    for option in "${aeh_options[@]}"; do
        if [ "$(grep "$option" "$kernel_config")" == "" ]; then
            exit 1
        fi
    done
    exit 0
  
}


function harden() {
    for option in "${aeh_options[@]}"; do
        if [ "$(grep "$option" "$kernel_config")" == "" ]; then
            echo "$option=y" >> "$kernel_config"
        fi
    done
    evaluate  
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "Abnormal event handling is a critical component of the kernel, and as such, it is important that it is configured in a secure manner."
else
    exit 1
fi

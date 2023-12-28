#!/bin/bash

ds_compile_options=(
  "CONFIG_DEBUG_CREDENTIALS"
  "CONFIG_DEBUG_NOTIFIERS"
  "CONFIG_DEBUG_LIST"
  "CONFIG_DEBUG_SG"
  "CONFIG_BUG_ON_DATA_CORRUPTION"
)

kernel_config="/boot/config-$(uname -r)"


function evaluate() {
    for option in "${ds_compile_options[@]}"; do
        if [ "$(grep "$option" "$kernel_config")" == "" ]; then
            exit 1
        fi
    done
    exit 0
}


function harden() {
    for option in "${ds_compile_options[@]}"; do
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
    echo "There are a number of sensitive data structures within the kernel, hosting important data to security. These structures are those that are conventionally targeted when a kernel vulnerability is exploited"
else
    exit 1
fi

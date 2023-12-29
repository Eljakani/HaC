#!/bin/bash

ip_kernel_options=(
  "CONFIG_IPV6"
  "CONFIG_SYN_COOKIES"
)

kernel_config="/boot/config-$(uname -r)"

function evaluate() {
    for option in "${ip_kernel_options[@]}"; do
        if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
            exit 1
        fi
    done
    exit 0
  
}


function harden() {

    for option in "${ip_kernel_options[@]}"; do
        if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
            echo "$option=y" >> $kernel_config
        fi
    done
    evaluate
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo ""
else
    exit 1
fi

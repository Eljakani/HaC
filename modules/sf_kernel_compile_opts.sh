#!/bin/bash

sf_options=(
  "CONFIG_SECCOMP"
  "CONFIG_SECCOMP_FILTER"
  "CONFIG_SECURITY"
  "CONFIG_SECURITY_YAMA"
  "CONFIG_SECURITY_WRITABLE_HOOKS"
)

kernel_config="/boot/config-$(uname -r)"
function evaluate() {
    for option in "${sf_options[@]}"; do
        if [ "$(grep "$option" "$kernel_config")" == "" ]; then
            exit 1
        fi
    done
    exit 0
  
}


function harden() {
    for option in "${sf_options[@]}"; do
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
    echo ""
else
    exit 1
fi

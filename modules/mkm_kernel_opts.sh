#!/bin/bash
mkm_options=(
  "CONFIG_MODULES"
  "CONFIG_STRICT_MODULE_RWX"
  "CONFIG_MODULE_SIG"
  "CONFIG_MODULE_SIG_FORCE"
  "CONFIG_MODULE_SIG_ALL"
  "CONFIG_MODULE_SIG_SHA512"
)

kernel_config="/boot/config-$(uname -r)"
function evaluate() {
    for option in "${mkm_options[@]}"; do
        if [ "$(grep "$option" "$kernel_config")" == "" ]; then
            exit 1
        fi
    done
    exit 0
  
}


function harden() {
    for option in "${mkm_options[@]}"; do
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

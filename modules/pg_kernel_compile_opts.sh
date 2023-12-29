#!/bin/bash
pg_kernel_options=(
  "CONFIG_GCC_PLUGINS"
  "CONFIG_GCC_PLUGIN_LATENT_ENTROPY"
  "CONFIG_GCC_PLUGIN_STACKLEAK"
  "CONFIG_GCC_PLUGIN_STRUCTLEAK"
  "CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL"
  "CONFIG_GCC_PLUGIN_RANDSTRUCT"
)

kernel_config="/boot/config-$(uname -r)"

function evaluate() {
    for option in "${pg_kernel_options[@]}"; do
        if [ "$(grep "$option" "$kernel_config")" == "" ]; then
            exit 1
        fi
    done
    exit 0

  
}


function harden() {
    for option in "${pg_kernel_options[@]}"; do
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
    echo "A set of recommended kernel compilation options to configure compiler plugins."
else
    exit 1
fi

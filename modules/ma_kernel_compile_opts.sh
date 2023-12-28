#!/bin/bash

ma_kernel_compile_options=(
  "CONFIG_SLAB_FREELIST_RANDOM"
  "CONFIG_SLUB"
  "CONFIG_SLAB_FREELIST_HARDENED"
  "CONFIG_SLAB_MERGE_DEFAULT"
  "CONFIG_SLUB_DEBUG"
  "CONFIG_PAGE_POISONING"
  "CONFIG_PAGE_POISONING_NO_SANITY"
  "CONFIG_PAGE_POISONING_ZERO"
  "CONFIG_COMPAT_BRK"
)

kernel_config="/boot/config-$(uname -r)"

function evaluate() {
    for option in "${ma_kernel_compile_options[@]}"; do
        if [ "$(grep "$option" "$kernel_config")" == "" ]; then
            exit 1
        fi
    done
    exit 0
  
}


function harden() {
    for option in "${ma_kernel_compile_options[@]}"; do
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
    echo "The kernel memory allocator is a critical component of the kernel, and as such, it is important that it is configured in a secure manner."
else
    exit 1
fi

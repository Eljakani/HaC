#!/bin/bash
memory_options=(
  "l1tf=full,force"
  "page_poison=on"
  "pti=on"
  "slab_nomerge=yes"
  "slub_debug=FZP"
  "spec_store_bypass_disable=seccomp"
  "spectre_v2=on"
  "mds=full,nosmt"
  "mce=0"
  "page_alloc.shuffle=1"
  "rng_core.default_quality=500"
) 

function evaluate() {
    kernel_cmdline=$(cat /proc/cmdline)
    for option in "${memory_options[@]}"; do
        if [[ $kernel_cmdline != *"$option"* ]]; then
            exit 1
        fi
    done
    exit 0
}


function harden() {
    # add kernelcommandline options
    if [ -f "/etc/default/grub" ]; then
        # backup grub config
        cp "/etc/default/grub" "/etc/default/grub.bak"
        for option in "${memory_options[@]}"; do
            sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$option /" "/etc/default/grub"
        done
        evaluate
    else
        exit 1
    fi
    
    
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

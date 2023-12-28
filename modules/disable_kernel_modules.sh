#!/bin/bash

function evaluate() {
    if grep -q "kernel.modules_disabled=1" "/etc/default/grub"; then
        exit 0
    else
        exit 1
    fi
  
}

function harden() {
    if [ -f "/etc/default/grub" ]; then
        cp "/etc/default/grub" "/etc/default/grub.bak"
        sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"kernel.modules_disabled=1 /" "/etc/default/grub"
        update-grub
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
    echo "It is recommended to block the loading of kernel modules by activating the kernel.modules_disabled configuration option"
else
    exit 1
fi

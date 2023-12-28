#!/bin/bash

function evaluate() {
    # check  if kernel parameter is set
    if grep -q "init_on_alloc=1" "/etc/default/grub"; then
        exit 0
    else
        exit 1
    fi
}


function harden() {
    # restrict core dumps using sysctl command
    if [ -f "/etc/default/grub" ]; then
        # backup grub config
        cp "/etc/default/grub" "/etc/default/grub.bak"
        sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"init_on_alloc=1 /" "/etc/default/grub"
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
    echo "It is recommended to protect the Linux kernel command line parameters command line parameters and initramfs so that they are checked during UEFI secure boot."
else
    exit 1
fi

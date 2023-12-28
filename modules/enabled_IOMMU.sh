#!/bin/bash

function evaluate() {
    # check if IOMMU is enabled
    if  grep -q "iommu=force" "/etc/default/grub"; then
        exit 0
    else
        exit 1
    fi
    
}


function harden() {
    # activate IOMMU in GRUB
    if [ -f "/etc/default/grub" ]; then
        # backup grub config
        cp "/etc/default/grub" "/etc/default/grub.bak"
        sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"iommu=force /" "/etc/default/grub"
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
    echo "It is recommended to enable IOMMU by adding the iommu=force directive to the list kernel parameters during boot in addition to those already present in the bootloader configuration files."
else
    exit 1
fi

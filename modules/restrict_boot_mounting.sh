#!/bin/bash

BOOT_PARTITION="/boot"
FSTAB_FILE="/etc/fstab"

function check_boot_mount() {
    grep -E "^\s*UUID=[^\s]+\s+$BOOT_PARTITION\s" $FSTAB_FILE | grep -qE '\s+noauto,users\s'
    return $?
}

function evaluate() {
    check_boot_mount
    if [ $? -ne 0 ]; then
        exit 1
    fi
    exit 0
  
}


function harden() {
    check_boot_mount
    if [ $? -ne 0 ]; then
        echo "UUID=$(blkid -s UUID -o value $BOOT_PARTITION) $BOOT_PARTITION ext4 noauto,users 0 0" >> $FSTAB_FILE
    fi
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

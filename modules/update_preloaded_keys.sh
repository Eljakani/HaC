#!/bin/bash

function evaluate() {
    exit 1
    
}


function harden() {
    exit 1
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "In the absence of preloaded key updates, any vulnerability in a signed version of a SHIM or boot loader can enable an attacker to bypass UEFI secure boot UEFI secure boot"
else
    exit 1
fi

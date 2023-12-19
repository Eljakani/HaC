#!/bin/bash

function evaluate() {
    random_1_or_0=$((RANDOM % 2))
    exit $random_1_or_0
}


function harden() {
    echo "Mode Harden in Module executed"
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

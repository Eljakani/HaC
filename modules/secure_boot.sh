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
    echo "UEFI Secure Boot is a mechanism for verifying the code loaded by UEFI. It is designed to prevent the execution of unsigned code by the machine."
else
    exit 1
fi

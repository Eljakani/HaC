#!/bin/bash

function evaluate() {
    
    if ! command -v mokutil &> /dev/null; then
        apt install mokutil -y
    fi
    # Check if Secure Boot is enabled using mokutil
    if mokutil --sb-state | grep -q "SecureBoot enabled"; then
        exit 0
    else
        exit 1
    fi
}


function harden() {
    if ! command -v mokutil &> /dev/null; then
        apt install mokutil -y
    fi
    { mokutil --enable-secure-boot && mokutil --enable-validation; } &> /dev/null
    evaluate
    
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

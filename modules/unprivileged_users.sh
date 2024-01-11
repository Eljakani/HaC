#!/bin/bash

sudo_binaries=("vi" "nano" "emacs" "gcc" "g++" "make" "python" "ruby" "perl" "java" "curl" "wget")

function evaluate() {
    
    for binary in "${sudo_binaries[@]}"; do
        if [ -x "$(command -v $binary 2>/dev/null)" ]; then
            exit 1
        fi
    done
    exit 0

  
}


function harden() {

    for binary in "${sudo_binaries[@]}"; do
        if [ -x "$(command -v $binary 2>/dev/null)" ]; then
            chmod 750 "$(command -v $binary 2>/dev/null)"
        fi
    done
    evaluate

    
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "The recommendation here is to avoid configuring sudo rules that allow non-privileged users (non-root users) to run certain commands that are functionally rich."
else
    exit 1
fi
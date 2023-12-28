#!/bin/bash

fs_options=(
  "fs.suid_dumpable"
  "fs.protected_fifos"
  "fs.protected_regular"
  "fs.protected_symlinks"
  "fs.protected_hardlinks"
)

function evaluate() {

    for option in "${fs_options[@]}"; do
        if [ "$(sysctl "$option" | awk '{print $3}')" == "0" ]; then
            exit 1
        fi
    done
  
}


function harden() {
    for option in "${fs_options[@]}"; do
        if [ "$(sysctl "$option" | awk '{print $3}')" == "0" ]; then
            sysctl -w "$option=1"
        fi
    done
    evaluate
    
    
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "It is recommended to enable all of the fs.protected_* sysctl options."
else
    exit 1
fi

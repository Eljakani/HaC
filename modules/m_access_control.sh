#!/bin/bash

function evaluate() {
    if lsmod | grep -q '^security'; then
        exit 0
    fi
    exit 1
  
}


function harden() {
    # enable MAC mechanism
    if ! lsmod | grep -q '^security'; then
        echo "security" >> /etc/modules
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

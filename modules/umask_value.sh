#!/bin/bash

function evaluate() {
    
    if [ "$(umask)" -lt 027 ]; then
        exit 1
    fi
    exit 0
  
}


function harden() {
    umask 077
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

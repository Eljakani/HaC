#!/bin/bash

function evaluate() {
    
    if [ -z "$(grep -E '^\s*TMOUT\s*=\s*[0-9]+' /etc/profile)" ]; then
        exit 1
    fi
    exit 0
  
}


function harden() {
    if [ -z "$(grep -E '^\s*TMOUT\s*=\s*[0-9]+' /etc/profile)" ]; then
        echo "TMOUT=600" >> /etc/profile
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

#!/bin/bash

function evaluate() {

    if [ -e "/usr/bin/sudo" ]; then
        sudo_group=$(stat -c %G /usr/bin/sudo 2>/dev/null)
        if [ $? -eq 0 ]; then
            if [ "$(stat -c %a /usr/bin/sudo)" = "4110" ]; then
                exit 0
            else
                exit 1
            fi
        else
            exit 1
        fi
    else
        exit 1
    fi
  
}


function harden() {
    if [ -e "/usr/bin/sudo" ]; then
        sudo_group=$(stat -c %G /usr/bin/sudo 2>/dev/null)
        if [ $? -eq 0 ]; then
            if [ "$(stat -c %a /usr/bin/sudo)" != "4110" ]; then
                chmod 4110 /usr/bin/sudo
            fi
        fi
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

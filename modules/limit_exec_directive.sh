#!/bin/bash

function evaluate() {

    if [ -f /etc/sudoers ]; then
        if [ "$(grep -E '^\s*ALL\s+ALL\s+!\s+ALL' /etc/sudoers)" ]; then
            exit 1
        fi
    fi
    exit 0
  
}


function harden() {
    # give only instructions to fix the issue
    whiptail --title "Limiting the number of commands requiring the use of the EXEC directive" --msgbox "You should not use the EXEC directive in the sudoers file to allow users to run commands as other users. Instead, use the USER directive to specify the users who are allowed to run commands as other users. For example, to allow the user 'bob' to run commands as the user 'alice', use the following directive: bob ALL=(alice) ALL" 10 60
    
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "The recommendation advises against using a negation or blacklist approach to specify access rights, as it is considered inefficient and easily circumvented."
else
    exit 1
fi

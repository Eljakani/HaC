#!/bin/bash

function evaluate() {
    # check if there are any unused accounts
    for user in $(cat /etc/passwd | cut -d: -f1); do
        if [ "$user" != "root" ] && [ "$user" != "nobody" ] && [ "$user" != "nogroup" ]; then
            if [ $(id -u $user) -ge 1000 ] && [ $(id -u $user) -lt 65534 ]; then
                if [ -z "$(sudo -u $user -H sh -c 'id')" ]; then
                    exit 1
                fi
            fi
        fi
    done
    exit 0
}


function harden() {
    # check if there are any unused accounts
    for user in $(cat /etc/passwd | cut -d: -f1); do
        if [ "$user" != "root" ] && [ "$user" != "nobody" ] && [ "$user" != "nogroup" ]; then
            if [ $(id -u $user) -ge 1000 ] && [ $(id -u $user) -lt 65534 ]; then
                if [ -z "$(sudo -u $user -H sh -c 'id')" ]; then
                    if (whiptail --title "Unused account" --yesno "The user $user is not used. Do you want to delete it?" 8 78); then
                        userdel $user
                    fi
                fi
            fi
        fi
    done
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

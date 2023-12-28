#!/bin/bash

function evaluate() {
    if grep -q "net.ipv6.conf.all.disable_ipv6=1" "/etc/sysctl.conf"; then
        exit 0
    else
        exit 1
    fi
  
}


function harden() {
    # ask for user confirmation using the whiptail dialog utility
    whiptail --title "Disabling IPv6" --yesno "Do you want to disable IPv6?\n\nNote: This will disable IPv6 for all network interfaces." --yes-button "I Confirm" --no-button "Cancel" 10 78
    if [ $? != 0 ]; then
        exit 1
    fi
    if [ -f "/etc/sysctl.conf" ]; then
        cp "/etc/sysctl.conf" "/etc/sysctl.conf.bak"
        echo "net.ipv6.conf.all.disable_ipv6=1" >> "/etc/sysctl.conf"
        sysctl -p
        evaluate
    else
        exit 1
    fi
    
    
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "When IPv6 is not used, it is recommended to disable the IPv6 stack."
else
    exit 1
fi

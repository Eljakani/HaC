#!/bin/bash


souders_file="/etc/sudoers.d/souders"

sudo_configs=("noexec" "requiretty" "use_pty" "umask=0077" "ignore_dot" "env_reset")

function evaluate() {
    # check if sudoers.d/souders exists
    if [ ! -f $souders_file ]; then
        exit 1
    fi
    for config in ${sudo_configs[@]}; do
        grep -qE "^\s*Defaults\s+$config" $souders_file
        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
    exit 0
  
}


function harden() {
    if [ ! -f $souders_file ]; then
        touch $souders_file
    fi
    for config in ${sudo_configs[@]}; do
        grep -qE "^\s*Defaults\s+$config" $souders_file
        if [ $? -ne 0 ]; then
            echo "Defaults $config" >> $souders_file
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

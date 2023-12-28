#!/bin/bash

function evaluate() {
    if grep -q "kernel.yama.ptrace_scope=1" "/etc/sysctl.conf"; then
        exit 0
    else
        exit 1
    fi
  
}


function harden() {
    if [ -f "/etc/sysctl.conf" ]; then
        cp "/etc/sysctl.conf" "/etc/sysctl.conf.bak"
        echo "kernel.yama.ptrace_scope=1" >> "/etc/sysctl.conf"
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
    echo "It is recommended to load the Yama security module at boot time, for example by passing the security=yama directive to the kernel, and to set the kernel configuration option kernel.yama.ptrace_scope a value of at least 1."
else
    exit 1
fi

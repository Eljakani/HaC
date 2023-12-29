#!/bin/bash

kb_options=(
  "CONFIG_KEXEC"
  "CONFIG_HIBERNATION"
  "CONFIG_BINFMT_MISC"
  "CONFIG_LEGACY_PTYS"
  "CONFIG_MODULES"
)

kernel_config="/boot/config-$(uname -r)"

function evaluate() {
    for option in "${kb_options[@]}"; do
        if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
            exit 1
        fi
    done
    exit 0
  
}


function harden() {
        for option in "${kb_options[@]}"; do
            if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
                echo "$option=y" >> $kernel_config
            fi
        done
        evaluate
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "Certain Linux kernel behaviors may unnecessarily increase the attack surface of the kernel. If these are not absolutely necessary, they should not be activated."
else
    exit 1
fi

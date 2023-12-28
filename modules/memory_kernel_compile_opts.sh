#!/bin/bash

memory_options=(
  "CONFIG_STRICT_KERNEL_RWX"
  "CONFIG_ARCH_OPTIONAL_KERNEL_RWX"
  "CONFIG_ARCH_HAS_STRICT_KERNEL_RWX"
  "CONFIG_DEBUG_WX"
  "CONFIG_DEBUG_FS"
  "CONFIG_STACKPROTECTOR"
  "CONFIG_STACKPROTECTOR_STRONG"
  "CONFIG_SCHED_STACK_END_CHECK"
  "CONFIG_HARDENED_USERCOPY"
  "CONFIG_HARDENED_USERCOPY_FALLBACK"
  "CONFIG_VMAP_STACK"
  "CONFIG_REFCOUNT_FULL"
  "CONFIG_FORTIFY_SOURCE"
  "CONFIG_ACPI_CUSTOM_METHOD"
  "CONFIG_DEVKMEM"
  "CONFIG_PROC_KCORE"
  "CONFIG_COMPAT_VDSO"
  "CONFIG_SECURITY_DMESG_RESTRICT"
  "CONFIG_RETPOLINE"
  "CONFIG_LEGACY_VSYSCALL_NONE"
  "CONFIG_LEGACY_VSYSCALL_EMULATE"
  "CONFIG_LEGACY_VSYSCALL_XONLY"
  "CONFIG_X86_VSYSCALL_EMULATION"
)

function evaluate() {
    for option in "${memory_options[@]}"; do
        if [ "$(grep "$option" /boot/config-$(uname -r))" == "" ]; then
            exit 1
        fi
    done
    exit 0
  
}


function harden() {
    for option in "${memory_options[@]}"; do
        if [ "$(grep "$option" /boot/config-$(uname -r))" == "" ]; then
            echo "$option=y" >> /boot/config-$(uname -r)
        fi
    done
    evaluate
    
    
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "kernel memory must be managed in a secure manner. There are various mechanisms for this, such as canaries, KASLR"
else
    exit 1
fi

#!/bin/bash

x64_options=(
  "CONFIG_X86_64"
  "CONFIG_DEFAULT_MMAP_MIN_ADDR"
  "CONFIG_RANDOMIZE_BASE"
  "CONFIG_RANDOMIZE_MEMORY"
  "CONFIG_PAGE_TABLE_ISOLATION"
  "CONFIG_IA32_EMULATION"
)
x32_options=(
  "CONFIG_HIGHMEM64G"
  "CONFIG_X86_PAE"
  "CONFIG_DEFAULT_MMAP_MIN_ADDR"
  "CONFIG_RANDOMIZE_BASE"
)
arm_options=(
  "CONFIG_DEFAULT_MMAP_MIN_ADDR"
  "CONFIG_VMSPLIT_3G"
  "CONFIG_STRICT_MEMORY_RWX"
  "CONFIG_CPU_SW_DOMAIN_PAN"
  "CONFIG_OABI_COMPAT"
)
arm64_options=(
  "CONFIG_DEFAULT_MMAP_MIN_ADDR"
  "CONFIG_RANDOMIZE_BASE"
  "CONFIG_ARM64_SW_TTBR0_PAN"
  "CONFIG_UNMAP_KERNEL_AT_EL0"
)

kernel_config="/boot/config-$(uname -r)"

function evaluate() {
    if [ "$(uname -m)" == "x86_64" ]; then
        for option in "${x64_options[@]}"; do
            if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
                exit 1
            fi
        done
    elif [ "$(uname -m)" == "i686" ]; then
        for option in "${x32_options[@]}"; do
            if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
                exit 1
            fi
        done
    elif [ "$(uname -m)" == "armv7l" ]; then
        for option in "${arm_options[@]}"; do
            if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
                exit 1
            fi
        done
    elif [ "$(uname -m)" == "aarch64" ]; then
        for option in "${arm64_options[@]}"; do
            if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
                exit 1
            fi
        done
    fi
    exit 0
  
}


function harden() {
    if [ "$(uname -m)" == "x86_64" ]; then
        for option in "${x64_options[@]}"; do
            if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
                echo "$option=y" >> $kernel_config
            fi
        done
    elif [ "$(uname -m)" == "i686" ]; then
        for option in "${x32_options[@]}"; do
            if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
                echo "$option=y" >> $kernel_config
            fi
        done
    elif [ "$(uname -m)" == "armv7l" ]; then
        for option in "${arm_options[@]}"; do
            if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
                echo "$option=y" >> $kernel_config
            fi
        done
    elif [ "$(uname -m)" == "aarch64" ]; then
        for option in "${arm64_options[@]}"; do
            if [ "$(grep -E "^${option}=y$" $kernel_config)" == "" ]; then
                echo "$option=y" >> $kernel_config
            fi
        done
    fi
    evaluate
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "The recommended kernel compilation options for all architectures focus on enhancing security and mitigating specific vulnerabilities."
else
    exit 1
fi

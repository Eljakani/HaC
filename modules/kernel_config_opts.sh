#!/bin/bash
kernel_params=(
  "kernel.dmesg_restrict"
  "kernel.kptr_restrict"
  "kernel.pid_max"
  "kernel.perf_cpu_time_max_percent"
  "kernel.perf_event_max_sample_rate"
  "kernel.perf_event_paranoid"
  "kernel.randomize_va_space"
  "kernel.sysrq"
  "kernel.unprivileged_bpf_disabled"
  "kernel.panic_on_oops"
)
sysctl_conf="/etc/sysctl.conf"
function evaluate() {
    for param in "${kernel_params[@]}"; do
        if ! grep -q "$param" "$sysctl_conf"; then
            exit 1
        fi
    done
    exit 0
  
}


function harden() {
    for param in "${kernel_params[@]}"; do
        if ! grep -q "$param" "$sysctl_conf"; then
            echo "$param" >> "$sysctl_conf"
        fi
    done
    sysctl -p
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

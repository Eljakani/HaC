#!/bin/bash

mount_points=("/boot" "/opt" "/tmp" "/srv" "/home" "/proc" "/usr" "/var" "/var/log" "/var/tmp")
mount_options=("nosuid,nodev,noexec" "nosuid,nodev" "nosuid,nodev,noexec" "nosuid,nodev" "nosuid,nodev,noexec" "hidepid=2,nodev" "nosuid,nodev,noexec" "nosuid,nodev,noexec" "nosuid,nodev,noexec")

function is_mounted_with_options() {
    local mpoint=$1
    local moptions=$2

    if mount | grep -q "$mpoint" && mount | grep "$mpoint" | grep -q "$moptions"; then
        return 0  # Mounted with specified options
    else
        return 1  # Not mounted or not with specified options
    fi
}

function evaluate() {
    for ((i = 0; i < ${#mount_points[@]}; i++)); do
        if ! is_mounted_with_options "${mount_points[$i]}" "${mount_options[$i]}"; then
            exit 1
        fi
    done
    exit 0
}

function harden() {
    for ((i = 0; i < ${#mount_points[@]}; i++)); do
        if ! is_mounted_with_options "${mount_points[$i]}" "${mount_options[$i]}"; then
            echo "${mount_points[$i]} ${mount_options[$i]} defaults 0 0" >> /etc/fstab
        fi
    done
    evaluate
}

case "$1" in
    "EV")
        evaluate
        ;;
    "HA")
        harden
        ;;
    "HELP")
        echo "The script checks and modifies mount options for specified mount points."
        ;;
    *)
        exit 1
        ;;
esac

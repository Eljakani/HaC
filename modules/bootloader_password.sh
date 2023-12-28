#!/bin/bash

function evaluate() {
    if command -v grub-mkpasswd-pbkdf2 &> /dev/null; then
        grub_config_file="/etc/default/grub"
        if [ -f "$grub_config_file" ]; then
            if grep -q "password_pbkdf2" "$grub_config_file"; then
                exit 0
            else
                exit 1
            fi
        else
            exit 1
        fi
    fi
}

function harden() {
    # check if grub-mkpasswd-pbkdf2 is installed and install if not
    if ! command -v grub-mkpasswd-pbkdf2 &> /dev/null; then
        apt install grub-pc-bin -y
    fi
    local valid_password=false
    while [ $valid_password = false ]; do
        # prompt for password using whiptail
        password=$(whiptail --passwordbox "Please enter a password for GRUB" 8 78 --title "GRUB Password" 3>&1 1>&2 2>&3)
        if [ $? != 0 ]; then
            confirm_exit
        fi
        password2=$(whiptail --passwordbox "Please enter the password again" 8 78 --title "GRUB Password" 3>&1 1>&2 2>&3)
        if [ $? != 0 ]; then
            confirm_exit
        fi
        # check if passwords match
        if [ $password != $password2 ]; then
            whiptail --msgbox "Passwords do not match" 8 78 --title "Error" 3>&1 1>&2 2>&3
        else
            valid_password=true
        fi
    done
    if [ $valid_password = true ]; then
        # create password hash
        password_hash=$(echo -e "$password\n$password" | grub-mkpasswd-pbkdf2 | grep -oP "(?<=grub\.pbkdf2\.sha512\.[[:digit:]]{1,2}\.).*")
        # add password to grub config
        grub_config_file="/etc/default/grub"
        if [ -f "$grub_config_file" ]; then
            cp "$grub_config_file" "$grub_config_file.bak"
            sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"password_pbkdf2 $password_hash /" "$grub_config_file"
            update-grub
            evaluate
        else
            exit 1
        fi
    else
        exit 1
    fi
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo "A bootloader that protects its boot by a password should be preferred. This password must prevent an ordinary user from changing the bootloader configuration options. When the bootloader does not offer the possibility to set a password, some other technical or organizational measures must be set up to block any user to change the settings"
else
    exit 1
fi

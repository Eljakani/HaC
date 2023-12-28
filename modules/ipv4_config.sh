#!/bin/bash
ipv4_params=(
  "net.core.bpf_jit_harden=2"
  "net.ipv4.ip_forward=0"
  "net.ipv4.conf.all.accept_local=0"
  "net.ipv4.conf.all.accept_redirects=0"
  "net.ipv4.conf.default.accept_redirects=0"
  "net.ipv4.conf.all.secure_redirects=0"
  "net.ipv4.conf.default.secure_redirects=0"
  "net.ipv4.conf.all.shared_media=0"
  "net.ipv4.conf.default.shared_media=0"
  "net.ipv4.conf.all.accept_source_route=0"
  "net.ipv4.conf.default.accept_source_route=0"
  "net.ipv4.conf.all.arp_filter=1"
  "net.ipv4.conf.all.arp_ignore=2"
  "net.ipv4.conf.all.route_localnet=0"
  "net.ipv4.conf.all.drop_gratuitous_arp=1"
  "net.ipv4.conf.default.rp_filter=1"
  "net.ipv4.conf.all.rp_filter=1"
  "net.ipv4.conf.default.send_redirects=0"
  "net.ipv4.conf.all.send_redirects=0"
  "net.ipv4.icmp_ignore_bogus_error_responses=1"
  "net.ipv4.ip_local_port_range='32768 65535'"
  "net.ipv4.tcp_rfc1337=1"
  "net.ipv4.tcp_syncookies=1"
)

function evaluate() {
    for param in "${ipv4_params[@]}"; do
        if ! grep -q "$param" "/etc/sysctl.conf"; then
            exit 1
        fi
    done
    exit 0
}


function harden() {
    whiptail --title "Warning" --yesno "These settings may cause issues with your network configuration. Are you sure you want to continue?" --yes-button "I understand" --no-button "Cancel" 10 78
    if [ $? != 0 ]; then
        exit 1
    fi
    for param in "${ipv4_params[@]}"; do
        if ! grep -q "$param" "/etc/sysctl.conf"; then
            echo "$param" >> "/etc/sysctl.conf"
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
    echo "A set of IPv4 network configuration options for a typical “server” host that does not perform routing and has a minimalistic IPv4 configuration (static addressing)"
else
    exit 1
fi

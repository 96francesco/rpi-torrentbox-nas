#!/bin/bash

# VPN connection monitor script
# This script checks if the VPN connection is active and implements a kill switch
# by stopping Transmission if the VPN connection drops.
# Assumptions:
# - VPN is running as a systemd service named 'vpn.service'
# - Transmission is running as 'transmission-daemon.service'. Any other BitTorrent client/framework will work fine.
# - There's a service 'vpn-reconnect.service' that handles VPN reconnection

if ! systemctl is-active --quiet vpn.service; then
    echo "VPN down, stopping Transmission"
    systemctl stop transmission-daemon.service
    
    # after stopping Transmission, trigger reconnection attempt
    echo "Triggering VPN reconnection"
    systemctl start vpn-reconnect.service
fi

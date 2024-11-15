#!/bin/bash

# Function to discover devices on the local network
discover_devices() {
    echo "Enter the subnet to scan (e.g., 192.168.1):"
    read subnet
    echo "Scanning for devices on $subnet.0/24..."
    for ip in {1..254}; do
        ping -c 1 -W 1 "$subnet.$ip" &>/dev/null && echo "Device found: $subnet.$ip" &
    done
    wait
    echo "Device discovery completed."
}

# Function to scan ports on a remote host
scan_ports() {
    echo "Enter the remote host to scan (e.g., 192.168.1.1):"
    read host
    echo "Enter ports to scan (e.g., 22,80,443) or 'all' to scan all ports:"
    read ports

    if [ "$ports" == "all" ]; then
        ports=$(seq 1 65535)
    else
        IFS=',' read -r -a ports <<< "$ports"
    fi

    echo "Scanning ports on $host..."
    for port in ${ports[@]}; do
        (echo > /dev/tcp/"$host"/"$port") &>/dev/null && echo "Port $port is open on $host" &
    done
    wait
    echo "Port scanning completed."
}

# Main menu
echo "Select an option:"
echo "1. Discover local network devices"
echo "2. Scan open ports on a remote host"
read choice

if [ "$choice" -eq 1 ]; then
    discover_devices
elif [ "$choice" -eq 2 ]; then
    scan_ports
else
    echo "Invalid choice. Exiting."
fi


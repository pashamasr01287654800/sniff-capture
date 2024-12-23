#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Display a thrilling welcome message
echo -e "${MAGENTA}========================================${RESET}"
echo -e "${CYAN}Welcome to the Packet Capture Adventure!${RESET}"
echo -e "${MAGENTA}========================================${RESET}"
echo -e "${CYAN}Are you ready to uncover the secrets hidden in the network?${RESET}"
echo -e "${CYAN}This tool will allow you to capture and analyze every packet that passes through the network.${RESET}"
echo -e "${CYAN}It’s time to dive into the unseen and unlock what’s being transmitted, unnoticed.${RESET}"
echo -e "${CYAN}But remember, with great power comes great responsibility...${RESET}"
echo -e "${CYAN}Every packet captured may hold crucial data, so tread carefully.${RESET}"
echo -e "${CYAN}Let's begin, and see what secrets lie ahead...${RESET}"
echo -e "${MAGENTA}========================================${RESET}"

# Function to display network interfaces
display_interfaces() {
    echo -e "${CYAN}Available network interfaces:${RESET}"
    interfaces=$(ifconfig -a | grep -oP '^\w+')
    i=1
    declare -gA iface_map
    while IFS= read -r line; do
        echo -e "${GREEN}[$i] $line${RESET}"
        iface_map["$i"]="$line"
        i=$((i + 1))
    done <<< "$interfaces"
}

# Display interfaces
display_interfaces

# Ask the user to select an interface
while true; do
    read -p "$(echo -e "${YELLOW}Enter the number of the interface you want to capture packets on: ${RESET}")" iface_number
    if [[ -n "${iface_map["$iface_number"]}" ]]; then
        selected_interface="${iface_map["$iface_number"]}"
        echo -e "${BLUE}You selected: $selected_interface${RESET}"
        break
    else
        echo -e "${RED}Invalid selection. Try again.${RESET}"
        display_interfaces
    fi
done

# Ask for file size
file_sizes=("10MB" "20MB" "30MB" "40MB" "50MB")
echo -e "${CYAN}Select file size for capture:${RESET}"
for i in "${!file_sizes[@]}"; do
    echo -e "${GREEN}[$((i + 1))] ${file_sizes[$i]}${RESET}"
done

while true; do
    read -p "$(echo -e "${YELLOW}Enter your choice: ${RESET}")" size_choice
    if [[ "$size_choice" =~ ^[1-5]$ ]]; then
        file_size=$((size_choice * 10240))
        echo -e "${BLUE}File size set to: ${file_sizes[$((size_choice - 1))]}${RESET}"
        break
    else
        echo -e "${RED}Invalid choice. Try again.${RESET}"
    fi
done

# Start packet capture
echo -e "${GREEN}Starting packet capture on $selected_interface...${RESET}"
tshark -i "$selected_interface" -w capture.pcap -b filesize:$file_size
echo -e "${CYAN}Packet capture in progress. Files saved as capture.pcap in ${file_sizes[$((size_choice - 1))]} chunks.${RESET}"
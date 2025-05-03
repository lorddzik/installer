#!/bin/bash

# Function to display the banner using Python
display_banner() {
python3 <<EOF
print(r"""
███████╗██╗     ███████╗ ██████╗████████╗██████╗  ██████╗      ██╗██████╗ ██████╗ ███████╗
██╔════╝██║     ██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗    ███║╚════██╗╚════██╗╚════██║
█████╗  ██║     █████╗  ██║        ██║   ██████╔╝██║   ██║    ╚██║ █████╔╝ █████╔╝    ██╔╝
██╔══╝  ██║     ██╔══╝  ██║        ██║   ██╔══██╗██║   ██║     ██║ ╚═══██╗ ╚═══██╗   ██╔╝ 
███████╗███████╗███████╗╚██████╗   ██║   ██║  ██║╚██████╔╝     ██║██████╔╝██████╔╝   ██║  
╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝      ╚═╝╚═════╝ ╚═════╝    ╚═╝                                                                                                                                                                                                                                                                                                                                                                                                                                      
                          Electro Playz
""")
EOF
}

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# Display the banner
display_banner

# Update and upgrade the system
echo "Updating package list..."
apt update -y
echo "Upgrading packages..."
apt upgrade -y

# Install Docker Compose
echo "Installing Docker Compose..."
apt install docker-compose -y

# Install Neofetch
echo "Installing Neofetch..."
apt install neofetch -y

# Run Neofetch to display system information
echo "Running Neofetch..."
neofetch

echo "All tasks completed successfully!"

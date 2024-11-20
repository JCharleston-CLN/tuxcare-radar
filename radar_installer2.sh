#!/bin/bash

# Prompt the user for the API key
read -p "Please enter your API key: " API_KEY

# Validate that an API key was provided
if [ -z "$API_KEY" ]; then
    echo "Error: API key cannot be empty. Exiting."
    exit 1
fi

# Function to validate that the configuration file contains the correct API key
validate_configuration() {
    CONFIG_FILE="/etc/tuxcare-radar/radar.yaml"
    if [ -f "$CONFIG_FILE" ]; then
        if grep -q "apikey: $API_KEY" "$CONFIG_FILE"; then
            echo "Configuration file is correctly set up with the provided API key."
        else
            echo "Error: Configuration file does not contain the correct API key."
            exit 1
        fi
    else
        echo "Error: Configuration file not found at $CONFIG_FILE."
        exit 1
    fi
}

# Detect the OS type
if [ -f /etc/redhat-release ]; then
    # RedHat, AlmaLinux, Oracle Linux, CentOS
    echo "Detected RedHat-based OS. Setting up TuxCare Radar repo..."
    cat > /etc/yum.repos.d/tuxcare-radar.repo <<EOL
[tuxcare-radar]
name=TuxCare Radar
baseurl=https://repo.tuxcare.com/radar/\$releasever/\$basearch/
enabled=1
gpgcheck=1
skip_if_unavailable=1
gpgkey=https://repo.tuxcare.com/radar/RPM-GPG-KEY-TuxCare
EOL
    echo "Installing TuxCare Radar software..."
    yum install -y tuxcare-radar
    if [ $? -eq 0 ]; then
        echo "TuxCare Radar installed successfully."
    else
        echo "Error: Failed to install TuxCare Radar."
        exit 1
    fi

elif [ -f /etc/debian_version ]; then
    # Debian/Ubuntu
    echo "Detected Debian/Ubuntu-based OS. Setting up TuxCare Radar repo..."
    curl -s https://repo.tuxcare.com/radar/tuxcare.gpg -o /usr/share/keyrings/tuxcare.gpg
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download the GPG key."
        exit 1
    fi

    source /etc/os-release
    printf '%s' \
      "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/tuxcare.gpg] " \
      "https://repo.tuxcare.com/radar/$ID/$VERSION_ID " \
      "stable main" > /etc/apt/sources.list.d/tuxcare-radar.list

    echo "Updating package lists..."
    apt-get update
    echo "Installing TuxCare Radar software..."
    apt-get install -y tuxcare-radar
    if [ $? -eq 0 ]; then
        echo "TuxCare Radar installed successfully."
    else
        echo "Error: Failed to install TuxCare Radar."
        exit 1
    fi
else
    echo "Unsupported OS. This script only supports RedHat-based or Debian/Ubuntu-based distributions."
    exit 1
fi

# Configure the software with the API key
echo "Configuring TuxCare Radar with the API key..."
sed -i "s/apikey:.*/apikey: $API_KEY/" /etc/tuxcare-radar/radar.yaml
if [ $? -eq 0 ]; then
    echo "TuxCare Radar configuration updated with the API key."
else
    echo "Error: Failed to configure TuxCare Radar with the API key."
    exit 1
fi

# Validate the configuration
validate_configuration

# Run TuxCare Radar as the 'nobody' user
echo "Running TuxCare Radar as 'nobody' user..."
su -s /bin/bash nobody -c "tuxcare-radar --config /etc/tuxcare-radar/radar.yaml"
if [ $? -eq 0 ]; then
    echo "TuxCare Radar executed successfully as 'nobody' user."
else
    echo "Error: TuxCare Radar execution failed."
    exit 1
fi

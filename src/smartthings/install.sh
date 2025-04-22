#!/bin/bash
set -e

# Variables
SMARTTHINGS_CLI_VERSION=${VERSION:-"latest"}
ARCH=${ARCH:-"x64"}
INSTALL_DIR="/usr/local/bin"

# Function to install SmartThings CLI
install_smartthings_cli() {
    echo "Installing SmartThings CLI version: $SMARTTHINGS_CLI_VERSION"

    apt update -y
    apt install -y curl tar

    # Download the latest release of SmartThings CLI
    curl -fsSL "https://github.com/SmartThingsCommunity/smartthings-cli/releases/download/%40smartthings%2Fcli%40${SMARTTHINGS_CLI_VERSION}/smartthings-linux-${ARCH}.tar.gz" -o smartthings-cli.tar.gz

    # Extract the tarball
    tar -xzf smartthings-cli.tar.gz

    # Move the binary to the install directory
    chmod +x smartthings
    mv smartthings "$INSTALL_DIR/smartthings"

    # Clean up
    rm -f smartthings-cli.tar.gz

    # Verify installation
    if command -v smartthings &> /dev/null; then
        echo "SmartThings CLI installed successfully!"
    else
        echo "Failed to install SmartThings CLI."
        exit 1
    fi
}

# Execute the installation
install_smartthings_cli
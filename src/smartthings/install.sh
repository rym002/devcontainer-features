#!/bin/bash
set -e

# Variables
SMARTTHINGS_CLI_VERSION=${VERSION:-"latest"}
ARCH=${ARCH:-"x64"}
INSTALL_DIR="/usr/local/bin"
POST_CREATE_SCRIPT="/workspaces/devcontainer-features/.devcontainer/smartthings/postCreateCommand.sh"


# Function to install SmartThings CLI
install_smartthings_cli() {
    echo "Installing SmartThings CLI version: $SMARTTHINGS_CLI_VERSION"

    apt update -y
    apt install -y curl tar xdg-utils

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

# Function to create a postContainerCreate script for autocomplete
create_post_create_script() {
    echo "Creating postContainerCreate script for SmartThings CLI autocomplete..."

    mkdir -p "$(dirname "$POST_CREATE_SCRIPT")"

    cat <<EOF > "$POST_CREATE_SCRIPT"
#!/bin/bash
set -e

HOME_DIR=\${CONTAINER_USER_HOME:-\${_REMOTE_USER_HOME:-\$HOME}}



echo "Linking SmartThings config directory to container user's home... \${HOME_DIR}"
mkdir -p \${HOME_DIR}/.config
ln -sf /mnt/@smartthings \${HOME_DIR}/.config/

echo "SmartThings config directory linked successfully."

# Enable SmartThings CLI autocomplete
printf 'eval \$(smartthings autocomplete:script bash)' >> \${HOME_DIR}/.bashrc
EOF

    chmod +x "$POST_CREATE_SCRIPT"
    echo "PostContainerCreate script created at $POST_CREATE_SCRIPT"
}



# Execute the installation
install_smartthings_cli

# Create the postContainerCreate script
create_post_create_script

echo "SmartThings CLI installation and setup completed."
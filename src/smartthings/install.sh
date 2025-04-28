#!/bin/bash
set -e

# Variables
SMARTTHINGS_CLI_VERSION=${VERSION:-"latest"}
ARCH=${ARCH:-"x64"}
INSTALL_DIR="/usr/local/bin"
POST_CREATE_SCRIPT="/workspaces/devcontainer-features/.devcontainer/smartthings/postCreateCommand.sh"
POST_ATTACH_SCRIPT="/workspaces/devcontainer-features/.devcontainer/smartthings/postAttachCommand.sh"


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

# Function to create a postContainerCreate script for autocomplete
create_post_container_script() {
    echo "Creating postContainerCreate script for SmartThings CLI autocomplete..."

    mkdir -p "$(dirname "$POST_CREATE_SCRIPT")"

    cat <<EOF > "$POST_CREATE_SCRIPT"
#!/bin/bash
set -e

# Enable SmartThings CLI autocomplete
echo "Setting up SmartThings CLI autocomplete..."
mkdir -p /etc/bash_completion.d
smartthings autocomplete:script bash > /etc/bash_completion.d/smartthings


EOF

    chmod +x "$POST_CREATE_SCRIPT"
    echo "PostContainerCreate script created at $POST_CREATE_SCRIPT"
}

# Function to create a postAttachCommand script for linking the mount
create_post_attach_script() {
    echo "Creating postAttachCommand script to link mount to container user config..."

    mkdir -p "$(dirname "$POST_ATTACH_SCRIPT")"

    cat <<EOF > "$POST_ATTACH_SCRIPT"
#!/bin/bash
set -e

# Link the SmartThings config directory to the container user's home directory
echo "Linking SmartThings config directory to container user's home..."

mkdir -p ${_CONTAINER_USER_HOME}/.config

if [ -h ${_CONTAINER_USER_HOME}/.config/@smartthings ]; then
    echo "Mount directory already linked."
else
    echo "Mount directory not linked, creating link..."
    if [ -d ${_CONTAINER_USER_HOME}/.config/@smartthings ]; then
        echo "Removing existing smartthings config directory..."
        rm -rf ${_CONTAINER_USER_HOME}/.config/@smartthings
    fi
    ln -sf /mnt/@smartthings ${_CONTAINER_USER_HOME}/.config/
fi

echo "SmartThings config directory linked successfully."
EOF

    chmod +x "$POST_ATTACH_SCRIPT"
    echo "PostAttachCommand script created at $POST_ATTACH_SCRIPT"
}


# Execute the installation
install_smartthings_cli

# Create the postContainerCreate script
create_post_container_script

# Create the postAttachCommand script
create_post_attach_script

echo "SmartThings CLI installation and setup completed."
#!/bin/bash
set -e

# Variables
SMARTTHINGS_CLI_VERSION=${VERSION:-"latest"}
ARCH=${ARCH:-"x64"}
INSTALL_DIR="/usr/local/bin"
POST_CREATE_SCRIPT="/workspaces/devcontainer-features/.devcontainer/smartthings/postCreateCommand.sh"
LUA_LIBS_VERSION=${LUA_LIBS_VERSION:-"v13_56"}
LUA_LIBS_DIR="/workspaces/lua_libs"
INSTALL_LUA_LIBS=${INSTALL_LUA_LIBS:-"true"}
AUTOCOMPLTE=${AUTOCOMPLETE:-"true"}
ENABLE_LOGIN=${ENABLE_LOGIN:-"true"}

# Function to install SmartThings CLI
install_smartthings_cli() {
    echo "Installing SmartThings CLI version: $SMARTTHINGS_CLI_VERSION"

    apt update -y
    apt install -y wget tar

    # Download the latest release of SmartThings CLI
    wget -O /tmp/smartthings-cli.tar.gz "https://github.com/SmartThingsCommunity/smartthings-cli/releases/download/%40smartthings%2Fcli%40${SMARTTHINGS_CLI_VERSION}/smartthings-linux-${ARCH}.tar.gz" 

    # Extract the tarball
    tar -xzf /tmp/smartthings-cli.tar.gz

    # Move the binary to the install directory
    chmod +x smartthings
    mv smartthings "$INSTALL_DIR/smartthings"

    # Verify installation
    if command -v smartthings &> /dev/null; then
        echo "SmartThings CLI installed successfully!"
    else
        echo "Failed to install SmartThings CLI."
        exit 1
    fi
}
# Function to install lua_libs
install_lua_libs() {
    echo "Installing lua_libs version: $LUA_LIBS_VERSION"
    wget -O /tmp/lua_libs-api.tar.gz https://github.com/SmartThingsCommunity/SmartThingsEdgeDrivers/releases/download/api${LUA_LIBS_VERSION}/lua_libs-api_${LUA_LIBS_VERSION}X.tar.gz 
    mkdir -p ${LUA_LIBS_DIR}
    tar -xzf /tmp/lua_libs-api.tar.gz -C ${LUA_LIBS_DIR}
}

install_login() {
    TZ=${TZ:-"Etc/UTC"}
    DEBIAN_FRONTEND=noninteractive
    apt install -y tzdata
    echo "Installing xdg-utils for CLI login..."
    # Install xdg-utils for CLI login
    apt install -y xdg-utils
}

# Function to create a postContainerCreate script for autocomplete
create_post_create_script() {
    echo "Creating postContainerCreate script for SmartThings CLI autocomplete..."

    mkdir -p "$(dirname "$POST_CREATE_SCRIPT")"

    cat <<EOF > "$POST_CREATE_SCRIPT"
#!/bin/bash
set -e

HOME_DIR=\${CONTAINER_USER_HOME:-\${_REMOTE_USER_HOME:-\$HOME}}


if [ ${AUTOCOMPLETE} = true ]
then
    echo "Linking SmartThings config directory to container user's home... \${HOME_DIR}"
    mkdir -p \${HOME_DIR}/.config
    ln -sf /mnt/@smartthings \${HOME_DIR}/.config/

    echo "SmartThings config directory linked successfully."

    # Enable SmartThings CLI autocomplete
    printf 'test ! -d ~/.cache/@smartthings/cli/autocomplete/ && smartthings autocomplete -r 2> /dev/null\n' >> \${HOME_DIR}/.bashrc
    printf 'eval \$(smartthings autocomplete:script bash)\n' >> \${HOME_DIR}/.bashrc
fi
EOF

    chmod +x "$POST_CREATE_SCRIPT"
    echo "PostContainerCreate script created at $POST_CREATE_SCRIPT"
}



# Execute the installation
install_smartthings_cli
if [ "${INSTALL_LUA_LIBS}" = "true" ]
then
    install_lua_libs
fi
if [ "${ENABLE_LOGIN}" = "true" ]
then
    install_login
fi

# Create the postContainerCreate script
create_post_create_script

# Clean up
rm -f /tmp/*.tar.gz

echo "SmartThings CLI installation and setup completed."
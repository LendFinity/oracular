#!/bin/bash

set -e

args=("$@")
# Install mode
INSTALL_MODE=${args[0]:-"unset"}

# Network
NETWORK="local"

source ./scripts/dfx/deploy_functions.sh

start_dfx() {
    echo "Attempting to create Alice's Identity"
    set +e

    if [ "$INSTALL_MODE" = "create" ]; then
        echo "Stopping DFX"
        dfx stop
        echo "Starting DFX"
        dfx start --clean --background --artificial-delay 0
    else
        return
    fi

    # Create identity
    dfx identity new --storage-mode=plaintext alice
    dfx identity use alice
    echo "Alice's Identity Created"
}

entry_point() {

    OWNER=$(dfx identity get-principal)

    if [ "$INSTALL_MODE" = "create" ]; then
        create "$NETWORK"
        INSTALL_MODE="install"
        deploy "$NETWORK" "$INSTALL_MODE" "$OWNER"

    elif [ "$INSTALL_MODE" = "upgrade" ] || [ "$INSTALL_MODE" = "reinstall" ]; then
        deploy "$NETWORK" "$INSTALL_MODE" "$OWNER"
    else
        echo "Usage: $0 <create|upgrade|reinstall>"
        exit 1
    fi
}

start_dfx

entry_point

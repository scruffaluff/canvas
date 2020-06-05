#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install VSCode if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$vscode_build" ]; then
    printf "^^^^^ VSCode build skipped. ^^^^^\n"
else
    printf "##### VSCode build starting. #####\n"

    # Source NVM configuration.
    . $NVM_DIR/nvm.sh

    # Install Yarn.
    nvm use 10
    npm install -g yarn

    # Build Theia IDE and download extensions.
    cd /usr/local/theia
    yarn
    yarn theia build
    yarn download
fi

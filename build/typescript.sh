#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install TypeScript if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$TYPESCRIPT_BUILD" ]; then
    printf "^^^^^ TypeScript build skipped.\n ^^^^^"
else
    printf "+++++ TypeScript build starting. +++++\n"

    # Create NVM root directory.
    mkdir $NVM_DIR

    # Install Node Version Manager and multiple Node versions.
    #
    # Flags:
    #     -S: Show errors.
    #     -f: Fail silently on server errors.
    #     -s: Disable progress bars.
    curl -Sfs https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

    # Source NVM configuration.
    . $NVM_DIR/nvm.sh

    # Install multiple Node versions using NVM.
    nvm install 13.12.0
    nvm install 12.16.1
    nvm install 10.19.0

    # Install Node packages.
    nvm use 13.12.0 && npm install -g gitmoji-cli

    # Esnure that all users can read and write to NVM files.
    #
    # Flags:
    #     -R: Apply modifications recursivley to a directory.
    #     a+rw: Give read and write permissions to all users.
    chmod -R a+rw $NVM_DIR
fi

#!/bin/bash
set -e


# Install TypeScript if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$TYPESCRIPT_BUILD" ]; then
    printf "^^^^^ TypeScript build skipped.\n ^^^^^"
else
    printf "+++++ TypeScript build starting. +++++\n"

    mkdir $NVM_DIR
    chmod a+rw $NVM_DIR

    # Install Node Version Manager and multiple Node versions.
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    . $NVM_DIR/nvm.sh
    nvm install 13.12.0
    nvm install 12.16.1
    nvm install 10.19.0

    # Install Node packages.
    npm install -g gitmoji-cli

    chmod -R a+rw $NVM_DIR
fi

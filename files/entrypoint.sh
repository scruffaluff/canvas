#!/bin/bash


# Execute host entrypoint script if it exists.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x ~/host/entrypoint.sh ]; then
    ~/host/entrypoint.sh
fi


# Load NVM.
. $NVM_DIR/nvm.sh

# Run Theia IDE server.
cd /usr/local/theia
nvm use 10
yarn start ~/host --hostname 0.0.0.0 --port 9765 &> ~/.canvas/theia.log

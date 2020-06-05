#!/bin/bash


# Load NVM.
. $NVM_DIR/nvm.sh

# Run Theia IDE server.
cd /usr/local/theia
nvm use 10
yarn start ~/host --hostname 0.0.0.0 --port 8080 &> ~/.canvas/theia.log

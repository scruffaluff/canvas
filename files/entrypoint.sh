#!/bin/bash


# Execute host entrypoint script if it exists.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x ~/host/entrypoint.sh ]; then
    # Dot is needed to persist exported variables.
    . ~/host/entrypoint.sh
fi


# Expand and execute Docker container command line arguments.
# Using exec command causes bug in Code Server where a terminal cannot start.
bash "$@"

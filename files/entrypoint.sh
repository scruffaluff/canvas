#!/bin/bash


# Execute host entrypoint script if it exists.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x ~/host/entrypoint.sh ]; then
    ~/host/entrypoint.sh
fi


# Execute Code Server if it exists.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x code-server ]; then
    code-server
fi


# Expand and execute Docker container command line arguments.
exec "$@"

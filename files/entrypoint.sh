#!/bin/bash


# Execute host entrypoint script if it exists.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x ~/host/entrypoint.sh ]; then
    ~/host/entrypoint.sh
fi


# Expand and execute Docker container command line arguments.
exec "$@"

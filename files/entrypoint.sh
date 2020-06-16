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
if [ -x /usr/bin/code-server ]; then
    code-server
else
    tail -f /dev/null
fi

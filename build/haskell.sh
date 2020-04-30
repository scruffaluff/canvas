#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install Haskell if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$haskell_build" ]; then
    printf "^^^^^ Haskell build skipped. ^^^^^\n"
else
    printf "+++++ Haskell build not yet supported. +++++\n"
fi

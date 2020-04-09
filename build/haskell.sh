#!/bin/bash
set -e


# Install Haskell if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$HASKELL_BUILD" ]; then
    printf "^^^^^ Haskell build skipped. ^^^^^\n"
else
    printf "+++++ Haskell build not yet supported. +++++\n"
fi

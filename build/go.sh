#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install Go if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$go_build" ]; then
    printf "^^^^^ Go build skipped. ^^^^^\n"
else
    printf "+++++ Go build not yet supported. +++++\n"
fi

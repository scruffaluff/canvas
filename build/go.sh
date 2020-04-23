#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install Go if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$GO_BUILD" ]; then
    printf "^^^^^ Go build skipped. ^^^^^\n"
else
    printf "+++++ Go build not yet supported. +++++\n"
fi

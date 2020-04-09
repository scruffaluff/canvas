#!/bin/bash
set -e


# Install C++ if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$CPP_BUILD" ]; then
    printf "^^^^^ C++ build skipped. ^^^^^\n"
else
    printf "+++++ C++ build not yet supported. +++++\n"
fi

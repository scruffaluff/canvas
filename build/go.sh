#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install Go if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$go_build" ]; then
    printf "^^^^^ Go build skipped. ^^^^^\n"
else
    printf "##### Go build starting. #####\n"

    # Download Go.
    #
    # Flags:
    #     -L: Follow redirect request.
    #     -O: Redirect output to file with remote name.
    #     -S: Show errors.
    #     -f: Fail silently on server errors.
    #     -s: (curl) Disable progress bars.
    curl -LOSfs https://dl.google.com/go/go1.15.linux-amd64.tar.gz

    # Install Go.
    #
    # Flags:
    #     -C: Change to given directory before performing any operation.
    #     -f: Use archive file. Must be third flag.
    #     -x: Extract files from an archive. Must be first flag.
    #     -z: Filter the archive through gzip. Must be second flag.
    tar -C /usr/local -xzf go1.15.linux-amd64.tar.gz

    # Remove Go archive.
    rm go1.15.linux-amd64.tar.gz

    # Check that Go was installed successfully.
    go version
fi

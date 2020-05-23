#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install C# if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$csharp_build" ]; then
    printf "^^^^^ C# build skipped. ^^^^^\n"
else
    printf "##### C# build starting. #####\n"

    curl -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb

    apt-get update
    apt-get install -y dotnet-sdk-3.1
    apt-get install -y aspnetcore-runtime-3.1
    apt-get install -y dotnet-runtime-3.1
fi

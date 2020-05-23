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

    # Download Microsoft package repository installer.
    curl -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
    # Install Microsoft package repository.
    dpkg -i packages-microsoft-prod.deb
    # Remove package installer.
    rm packages-microsoft-prod.deb

    # Install C# frameworks, runtimes, and package managers.
    #
    # Flags:
    #     -m: Ignore missing packages and handle result.
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get update -m && apt-get install -y --no-install-recommends \
		aspnetcore-runtime-3.1 \
        dotnet-runtime-3.1 \
        dotnet-sdk-3.1 \
        nuget

    # Check that dotnet and nuget were installed successfully.
    dotnet --version
    nuget help
fi

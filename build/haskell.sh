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

    # Install Haskell platform.
    #
    # Flags:
    #     -m: Ignore missing packages and handle result.
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    # apt-get update -m && apt-get install -qy --no-install-recommends \
	#	 haskell-platform

    # Install Stack.
    #
    # Flags:
    #     -L: Follow redirect request.
    #     -S: Show errors.
    #     -s: Disable progress bars.
    curl -LSs https://get.haskellstack.org/ | sh
fi

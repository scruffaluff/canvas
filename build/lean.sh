#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install Lean if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$haskell_build" ]; then
    printf "^^^^^ Lean build skipped. ^^^^^\n"
else
    printf "+++++ Lean build not yet supported. +++++\n"

    # Lean installation commands were taken from
    # https://github.com/leanprover-community/mathlib-tools/blob/master/scripts/install_debian.sh.

    # Install Lean required dependencies.
    #
    # Flags:
    #     -m: Ignore missing packages and handle result.
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get update -m && apt-get install -y --no-install-recommends \
        git \
        curl \
        python3 \
        python3-pip \
        python3-venv

    # Install elan (Lean version manager).
    #
    # Flags:
    curl -LOSs https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh | sh -s -- -y --no-modify-path

    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    pipx install mathlibtools
fi

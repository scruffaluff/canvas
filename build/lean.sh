#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install Lean if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "${lean_build}" ]; then
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
  curl -LOSs "https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh" | sh -s -- -y --no-modify-path

  # Create Pipx home directory.
  mkdir -p "${PIPX_HOME}"

  # Install Pipx and command line Python applications.
  /usr/bin/python3 -m pip install pipx
  pipx install mathlibtools

  # Esnure that all users can read and write to Pipx files.
  #
  # Flags:
  #     -R: Apply modifications recursivley to a directory.
  #     777: Give read, write, and execute permissions to all users.
  chmod -R 777 "${PIPX_HOME}"
fi

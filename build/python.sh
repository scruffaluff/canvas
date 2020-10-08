#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Find latest Pyenv supported Python version with prefix.
#
# Arguments:
#     Python version prefix.
latest_version() {
    local list=$(pyenv install --list)
    local matches=$
    echo $(pyenv install --list | grep -E "^\s+$1.[0-9]+$" | tail -1)
}


# Install Python if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$python_build" ]; then
    printf "^^^^^ Python build skipped. ^^^^^\n"
else
    printf "##### Python build starting. #####\n"

    # Install system Python packages.
    #
    # Flags:
    #     -m: Ignore missing packages and handle result.
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get update -m && apt-get install -y --no-install-recommends \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv

    # Make system Python discoverable by Pyenv.
    #
    # Command taken from
    # https://github.com/pyenv/pyenv/issues/1613#issuecomment-640195879.
    #
    # Flags:
    #     -s: Make symbolic links instead of hard links.
    ln -s /usr/bin/python3 /usr/bin/python

    # Create Pipx home directory.
    mkdir -p $PIPX_HOME

    # Install Pipx and command line Python applications.
    /usr/bin/python3 -m pip install pipx wheel
    pipx install cookiecutter
    pipx install gdbgui
    pipx install poetry

    # Esnure that all users can read and write to Pipx files.
    #
    # Flags:
    #     -R: Apply modifications recursivley to a directory.
    #     777: Give read, write, and execute permissions to all users.
    chmod -R 777 $PIPX_HOME

    # Install Pyenv required dependencies.
    #
    # List taken from
    # https://github.com/pyenv/pyenv/wiki/Common-build-problems#prerequisites.
    #
    # Flags:
    #     -m: Ignore missing packages and handle result.
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get update -m && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        libbluetooth-dev \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        llvm \
        python-openssl \
        tk-dev \
        uuid-dev \
        wget \
        xz-utils \
        zlib1g-dev
    
    # Install ONNX required utilites.
    #
    # Flags:
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get install -qy --no-install-recommends \
        cmake \
        libprotoc-dev \
        protobuf-compiler

    # Install Pyenv.
    #
    # Flags:
    #     -S: Show errors.
    #     -f: Fail silently on server errors.
    #     -s: Disable progress bars.
    curl -Sfs https://pyenv.run | bash

    # Install multiple Python versions using Pyenv.
    pyenv install 3.9.0
    pyenv install 3.8.6
    pyenv install 3.7.9
    pyenv install 3.6.12

    # Set globally accessible Python versions.
    # First version is the global default.
    pyenv global 3.9.0 3.8.6 3.7.9 3.6.12

    # No checks for successful Python installations since Pyenv needs to
    # source shell profiles beforehand.

    # Upgrade pip for each Python version.
    #
    # Flags:
    #     -m: Run library module as a script.
    $PYENV_ROOT/shims/python3.6 -m pip install --upgrade pip
    $PYENV_ROOT/shims/python3.7 -m pip install --upgrade pip
    $PYENV_ROOT/shims/python3.8 -m pip install --upgrade pip
    $PYENV_ROOT/shims/python3.9 -m pip install --upgrade pip

    # Install globally accessible packages for each Python version.
    #
    # Flags:
    #     -m: Run library module as a script.
    $PYENV_ROOT/shims/python3.6 -m pip install wheel
    $PYENV_ROOT/shims/python3.7 -m pip install wheel
    $PYENV_ROOT/shims/python3.8 -m pip install wheel
    $PYENV_ROOT/shims/python3.9 -m pip install wheel

    # Esnure that all users can read and write to Pyenv Python files.
    #
    # Flags:
    #     -R: Apply modifications recursivley to a directory.
    #     777: Give read, write, and execute permissions to all users.
    chmod -R 777 $PYENV_ROOT

    # Create Jupyter settings folder and give permissions for all users.
    # Needed since Jupyter will try to create the folder on startup and will
    # not have permissions.
    mkdir /usr/local/jupyter && chmod 777 /usr/local/jupyter
fi

#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install specific version of Python with Pyenv.
#
# Arguments:
#     Python version string.
pyenv_install() {
    # Install Python version using Pyenv.
    pyenv install $version

    # Install or update packages for Python version.
    #
    # Flags:
    #     -m: Run library module as a script.
    $PYENV_ROOT/versions/$1/bin/pip install --upgrade pip setuptools wheel
}


# Find latest patch release for a Python version prefix.
#
# Arguments:
#     Python version prefix.
pyenv_version() {
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

    # Get latest patch versions based on Python prefixes.
    prefixes=("3.9" "3.8" "3.7" "3.6")
    versions=()
    for prefix in ${prefixes[@]}; do
        versions+="$(pyenv_version $prefix) "
    done

    # Install multiple Python versions concurrently.
    for version in ${versions[@]}; do
        pyenv_install $version &
    done
    wait

    # Set globally accessible Python versions.
    # First version is the global default.
    pyenv global ${versions[@]}

    # No checks for successful Python installations since Pyenv needs to
    # source shell profiles beforehand.

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

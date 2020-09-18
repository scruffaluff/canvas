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

    # Install Python recommend dependencies
    #
    # Flags:
    #     -m: Ignore missing packages and handle result.
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get update -m && apt-get install -y --no-install-recommends \
		libbluetooth-dev \
		tk-dev \
		uuid-dev
    
    # Install ONNX required utilites.
    # https://github.com/pyenv/pyenv/wiki/Common-build-problems#prerequisites
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
    pyenv install 3.8.5
    pyenv install 3.7.9
    pyenv install 3.6.12

    # Set globally accessible Python versions.
    # First version is the global default.
    pyenv global 3.8.5 3.7.9 3.6.12

    # No checks for successful Python installations since Pyenv needs to
    # source shell profiles beforehand.

    # Upgrade pip for each Python version.
    #
    # Flags:
    #     -m: Run library module as a script.
    /usr/local/pyenv/shims/python3.8 -m pip install --upgrade pip
    /usr/local/pyenv/shims/python3.7 -m pip install --upgrade pip
    /usr/local/pyenv/shims/python3.6 -m pip install --upgrade pip

    # Install globally accessible packages for each Python version.
    #
    # Flags:
    #     -m: Run library module as a script.
    /usr/local/pyenv/shims/python3.6 -m pip install poetry wheel
    /usr/local/pyenv/shims/python3.7 -m pip install poetry wheel
    /usr/local/pyenv/shims/python3.8 -m pip install \
        cookiecutter \
        gdbgui \
        poetry \
        pre-commit \
        typer \
        wheel

    # Esnure that all users can read and write to Pyenv Python files.
    #
    # Flags:
    #     -R: Apply modifications recursivley to a directory.
    #     a+rw: Give read and write permissions to all users.
    chmod -R a+rw $PYENV_ROOT

    # Create Jupyter settings folder and give permissions for all users.
    # Needed since Jupyter will try to create the folder on startup and will
    # not have permissions.
    mkdir /usr/local/jupyter && chmod 777 /usr/local/jupyter
fi

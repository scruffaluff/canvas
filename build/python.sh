#!/bin/bash
set -e


# Install Python if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$PYTHON_BUILD" ]; then
    printf "^^^^^ Python build skipped. ^^^^^\n"
else
    printf "##### Python build starting. #####\n"
    
    # Install Pyenv.
    #
    # Flags:
    #     -L: Follow redirect if requested from endpoint.
    #     -S: Show error message if curl request fails.
    #     -s: Silent mode, i.e. do not show progress bar.
    curl -LSs https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

    # Initialize Pyenv.
    #
    # Flags:
    #     -e: Enable interpretation of backslash escapes.
    #     -n: Do not output the trailing newline.
    echo -en "\n$(pyenv init -)\n$(pyenv virtualenv-init -)\n" >> $HOME/.bashrc

    # Install multiple Python versions.
    pyenv install 3.6.10
    pyenv install 3.7.7
    pyenv install 3.8.2

    # Set globally available Python versions.
    # First version is the default.
    pyenv global 3.8.2 3.7.7 3.6.10

    # Upgrade pip for each Python version.
    python3.6 -m pip install --upgrade pip
    python3.7 -m pip install --upgrade pip
    python3.8 -m pip install --upgrade pip

    # Install Poetry for multiple Python versions.
    python3.6 -m pip install --user poetry
    python3.7 -m pip install --user poetry

    # Install user wide packages for default Python version.
    python3.8 -m pip install --user \
        pipx \
        typer

    # Install CLI Pipx packages.
    pipx install cookiecutter
    pipx install poetry
fi

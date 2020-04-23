#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install Python if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$PYTHON_BUILD" ]; then
    printf "^^^^^ Python build skipped. ^^^^^\n"
else
    printf "##### Python build starting. #####\n"

    # Install Python recommend dependencies
    #
    # Flags:
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get update && apt-get install -y --no-install-recommends \
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

    # git clone git://github.com/pyenv/pyenv.git
    # cd pyenv/plugins/python-build
    # ./install.sh
    # python-build 3.8.2 /usr/local/lib/python3.8
    # ln -s /usr/local/lib/python3.8/bin/python3.8 /usr/local/bin/python3.8
    # python3.8 -m pip install --upgrade pip

    curl https://pyenv.run | bash

    pyenv install 3.8.2
    pyenv install 3.7.7
    pyenv install 3.6.10

    pyenv global 3.8.2 3.7.7 3.6.10

    /usr/local/pyenv/shims/python3.8 -m pip install --upgrade pip
    /usr/local/pyenv/shims/python3.7 -m pip install --upgrade pip
    /usr/local/pyenv/shims/python3.6 -m pip install --upgrade pip

    /usr/local/pyenv/shims/python3.6 -m pip install poetry typer
    /usr/local/pyenv/shims/python3.7 -m pip install poetry typer
    /usr/local/pyenv/shims/python3.8 -m pip install \
        cookiecutter \
        gdbgui \
        poetry \
        pre-commit \
        typer

    chmod -R a+rw $PYENV_ROOT
fi

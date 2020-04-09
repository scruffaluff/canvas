#!/bin/bash
set -e


# Set system timezone to void tzdata interactive prompts.
#
# Flags:
#     -f: Remove existing destination files.
#     -n: Treat link as normal file if it is a symbolic link to a directory.
#     -s: Make symbolic links instead of hard links.
ln -fns /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Update Apt package list.
#
# Flags:
#     -m: Ignore missing packages and handle result.
apt-get update -m

# Install developer desired utilites.
#
# Flags:
#     -q: Produce log suitable output by omitting progress indicators.
#     -y: Assume "yes" as answer to all prompts and run non-interactively.
#     --no-install-recommends: Do not install recommended packages.
apt-get install -qy --no-install-recommends \
    apt-utils \
    build-essential \
    ca-certificates \
    curl \
    git \
    git-lfs \
    llvm \
    make \
    openssh-client \
    openssh-server \
    openssl \
    vim


# Install Fixuid
curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf -
chown root:root /usr/local/bin/fixuid
chmod 4755 /usr/local/bin/fixuid
mkdir -p /etc/fixuid &&
printf "user: canvas\ngroup: canvas\n" > /etc/fixuid/config.yml


# Install Python utilities if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$PYTHON_BUILD" ]; then
    printf "^^^^^ Skipping Python utilities. ^^^^^\n"
else
    printf "##### Installing Python utilities. #####\n"

    # Install Pyenv required utilites.
    # https://github.com/pyenv/pyenv/wiki/Common-build-problems#prerequisites
    #
    # Flags:
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get install -qy --no-install-recommends \
        build-essential \
        curl \
        git \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        llvm \
        make \
        python-openssl \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev

    # Install ONNX required utilites.
    # https://github.com/pyenv/pyenv/wiki/Common-build-problems#prerequisites
    #
    # Flags:
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get install -qy --no-install-recommends \
        cmake \
        protobuf-compiler
fi


# Install Rust utilities if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$RUST_BUILD" ]; then
    printf "^^^^^ Skipping Rust utilities. ^^^^^\n"
else
    printf "##### Installing Rust utilities. #####\n"

    # Install Rust desired utilites.
    #
    # Flags:
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get install -qy --no-install-recommends \
        lldb \
        llvm
fi

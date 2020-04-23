#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Set system timezone to void tzdata interactive prompts.
#
# Flags:
#     -f: Remove existing destination files.
#     -n: Treat link as normal file if it is a symbolic link to a directory.
#     -s: Make symbolic links instead of hard links.
ln -fns /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone


# Install developer desired utilites.
#
# Flags:
#     -m: Ignore missing packages and handle result.
#     -q: Produce log suitable output by omitting progress indicators.
#     -y: Assume "yes" as answer to all prompts and run non-interactively.
#     --no-install-recommends: Do not install recommended packages.
apt-get update -m && apt-get install -qy --no-install-recommends \
    apt-utils \
    build-essential \
    ca-certificates \
    curl \
    fonts-powerline \
    git \
    git-lfs \
    hub \
    iputils-ping \
    lldb \
    llvm \
    make \
    openssh-client \
    openssh-server \
    openssl \
    powerline \
    texlive \
    tmux \
    vim \
    zsh \
    zsh-syntax-highlighting


# Install Fixuid for dynamically editing file permissions.
#
# Flags:
#     -C: Change to given directory before performing any operation.
#     -L: Follow redirect request.
#     -S: Show errors.
#     -f: Use archive file.
#     -s: (curl) Disable progress bars.
#     -x: Extract files from an archive.
#     -z: Filter the archive through gzip.
curl -LSs https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -fxz -
# Make root user ownder of Fixuid.
chown root:root /usr/local/bin/fixuid
# Change Fixuid executable permissions.
# The starting 4 attribute sets the file to run as owner regardless of which 
# user is executing it.
chmod 4755 /usr/local/bin/fixuid
# Create configuration file parent directory.
mkdir -p /etc/fixuid
# Write settings to configuration file.
printf "user: canvas\ngroup: canvas\npaths:\n  - /home/canvas" > /etc/fixuid/config.yml


# Install Oh My Zsh
#
# Flags:
#     -c: Read commands from the command string operand.
#     -L: Follow redirect request.
#     -S: Show errors.
#     -f: Fail silently on server errors.
#     -s: (curl) Disable progress bars.
sh -c "$(curl -LSfs https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

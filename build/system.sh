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
#     -C:
#     -L: 
#     -S:
#     -f:
#     -s:
#     -x:
#     -z:
curl -LSs https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -fxz -
# Make root user ownder of Fixuid.
chown root:root /usr/local/bin/fixuid
#
chmod 4755 /usr/local/bin/fixuid
#
mkdir -p /etc/fixuid &&
printf "user: canvas\ngroup: canvas\npaths:\n  - /home/canvas" > /etc/fixuid/config.yml


# Install Oh My Zsh
#
# Flags:
#     -c:
#
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

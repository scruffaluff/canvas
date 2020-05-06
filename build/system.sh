#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Download and install tar binary to /usr/local/bin.
#
# Arguments:
#     Binary remote URL.
#     Binary name.
install_tar() {
    # Get current working directory.
    cwd=$(pwd)
    # Change to tmp directory.
    cd /tmp

    # Download binary.
    #
    # Flags:
    #     -L: Follow redirect request.
    #     -S: Show errors.
    #     -f: Use archive file. Must be third flag.
    #     -s: Disable progress bars.
    #     -x: Extract files from an archive. Must be first flag.
    #     -z: Filter the archive through gzip. Must be second flag.
    curl -LSs $1 | tar -xzf -

    # Get binary file.
    # Check if binary file was extracted from tar.
    if [ -f $2 ]; then
        mv $2 /usr/local/bin
    # Else assume that binary file exists in an extracted folder.
    else
        # Extract folder stem from URL.
        #
        # Flags:
        #     -P: Interpret pattern as Perl regular expression.
        #     -o: Print only the matched parts of a line.
        #     <<<: Expand word to the command on its standard input.
        local directory=$(grep -Po '[^/]+(?=\.tar\.gz$)' <<< $1)
        # Move binary from directory.
        mv $directory/$2 /usr/local/bin
    fi

    # Make root user owner of binary.
    chown root:root /usr/local/bin/$2
    # Change binary executable permissions.
    chmod 755 /usr/local/bin/$2

    # Change back to previous working directory.
    cd $cwd
}

# Download and install zip binary to /usr/local/bin.
#
# Arguments:
#     Binary remote URL.
#     Binary name.
install_zip() {
    # Get current working directory.
    cwd=$(pwd)
    # Change to tmp directory.
    cd /tmp

    # Download binary.
    #
    # Flags:
    #     -L: Follow redirect request.
    #     -S: Show errors.
    #     -s: Disable progress bars.
    curl -LSs $1 -o "$2.zip"

    # Unzip and delete archive.
    unzip "$2.zip" && rm "$2.zip"
    # Move binary to /usr/local/bin.
    mv $2 /usr/local/bin/$2

    # Make root user owner of binary.
    chown root:root /usr/local/bin/$2
    # Change binary executable permissions.
    chmod 755 /usr/local/bin/$2

    # Change back to previous working directory.
    cd $cwd
}


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
    fzf \
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
    ripgrep \
    texlive \
    tmux \
    unzip \
    vim \
    zsh \
    zsh-syntax-highlighting


# Install additional utilities.
# Bat
install_tar https://github.com/sharkdp/bat/releases/download/v0.15.0/bat-v0.15.0-x86_64-unknown-linux-gnu.tar.gz bat
# Delta for Git.
install_tar https://github.com/dandavison/delta/releases/download/0.1.1/delta-0.1.1-x86_64-unknown-linux-musl.tar.gz delta
# MdBook.
install_tar https://github.com/rust-lang/mdBook/releases/download/v0.3.7/mdbook-v0.3.7-x86_64-unknown-linux-gnu.tar.gz mdbook
# Packer.
install_zip https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_linux_amd64.zip packer
# Terraform
install_zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip terraform


# Install Fixuid for dynamically editing file permissions.
#
# Flags:
#     -C: Change to given directory before performing any operation.
#     -L: Follow redirect request.
#     -S: Show errors.
#     -f: Use archive file. Must be third flag.
#     -s: (curl) Disable progress bars.
#     -x: Extract files from an archive. Must be first flag.
#     -z: Filter the archive through gzip. Must be second flag.
curl -LSs https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf -
# Make root user owner of Fixuid.
chown root:root /usr/local/bin/fixuid
# Change Fixuid executable permissions.
# The starting 4 attribute sets the file to run as owner regardless of which 
# user is executing it.
chmod 4755 /usr/local/bin/fixuid
# Create configuration file parent directory.
mkdir -p /etc/fixuid
# Write settings to configuration file.
printf "user: canvas\ngroup: canvas\npaths:\n  - /home/canvas" > /etc/fixuid/config.yml

#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Download and install tar binary to /usr/local/bin.
#
# Arguments:
#     Binary remote URL.
#     Binary name.
install_tar() {
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

    # Change back to tmp directory.
    cd /tmp
}

# Download and install zip binary to /usr/local/bin.
#
# Arguments:
#     Binary remote URL.
#     Binary name.
install_zip() {
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

    # Change back to tmp directory.
    cd /tmp
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
    apt-transport-https \
    apt-utils \
    bash-completion \
    bsdmainutils \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    fonts-powerline \
    fish \
    fzf \
    git \
    git-lfs \
    gcc \
    g++ \
    groff \
    hub \
    iputils-ping \
    less \
    libtinfo5 \
    lldb \
    llvm \
    make \
    neovim \
    net-tools \
    openssh-client \
    openssh-server \
    openssl \
    powerline \
    ripgrep \
    texlive \
    tmux \
    unzip \
    zsh \
    zsh-syntax-highlighting


# Configure Neovim
mkdir /usr/local/nvim
chmod 777 -R /usr/local/nvim


# Install additional utilities.
# 1Password
install_zip https://cache.agilebits.com/dist/1P/op/pkg/v1.2.1/op_linux_amd64_v1.2.1.zip op
# Bat
install_tar https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-v0.15.4-x86_64-unknown-linux-gnu.tar.gz bat
# Delta for Git.
install_tar https://github.com/dandavison/delta/releases/download/0.3.0/delta-0.3.0-x86_64-unknown-linux-musl.tar.gz delta
# MdBook.
install_tar https://github.com/rust-lang/mdBook/releases/download/v0.4.1/mdbook-v0.4.1-x86_64-unknown-linux-gnu.tar.gz mdbook
# Packer.
install_zip https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip packer
# Terraform
install_zip https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip terraform


# Download AWS CLI.
#
# Flags:
#     -L: Follow redirect request.
#     -S: Show errors.
#     -s: Disable progress bars.
#     -o: Write output to given file instead of stdout.
curl -LSs https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
# Unzip and delete archive.
unzip awscliv2.zip && rm awscliv2.zip
# Install AWS CLI
/tmp/aws/install
# Check that AWS CLI was successfully installed.
aws --version


# Install Starship for shell prompts.
#
# Flags:
#     -L: Follow redirect request.
#     -S: Show errors.
#     -f: Fail silently on server errors.
#     -s: (curl) Disable progress bars.
#     -s: (sh) Read commands from standard input.
#     -y: Skip confirmation prompt.
curl -LSfs https://starship.rs/install.sh | bash -s -- -y


# Donwload Data Version Control package.
#
# Flags:
#     -L: Follow redirect request.
#     -S: Show errors.
#     -s: Disable progress bars.
#     -o: Write output to given file instead of stdout.
curl -LOSfs https://github.com/iterative/dvc/releases/download/1.1.10/dvc_1.1.10_amd64.deb
# Install Data Version Control.
apt-get install ./dvc_1.1.10_amd64.deb


# Install Terragrunt.
#
# Flags:
#     -L: Follow redirect request.
#     -S: Show errors.
#     -s: Disable progress bars.
#     -o: Write output to given file instead of stdout.
curl -LSs https://github.com/gruntwork-io/terragrunt/releases/download/v0.23.31/terragrunt_linux_amd64 -o /usr/local/bin/terragrunt
# Change Terragrunt executable permissions.
chmod 755 /usr/local/bin/terragrunt


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
curl -LSs https://github.com/boxboat/fixuid/releases/download/v0.5/fixuid-0.5-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf -
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

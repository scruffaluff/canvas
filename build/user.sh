#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Create non-priviledged user.
#
# Flags:
#     -l: Do not add user to lastlog database.
#     -m: Create user home directory if it does not exist.
#     -s /usr/bin/fish: Set user login shell to Fish.
#     -u 1000: Give new user UID value 1000.
useradd -lm -s /usr/bin/fish -u 1000 canvas


# Configure sudo for standard user.

# Install sudo.
apt-get update && apt-get install -y sudo

# Add standard user to sudoers group.
usermod -a -G sudo canvas

# Allow sudo commands with no password.
#
# Flags:
#     -e: Enable interpretation of backslash escapes.
#     -n: Do not output the trailing newline.
printf "%%sudo ALL=(ALL) NOPASSWD:ALL\n" >> /etc/sudoers

# Disable sudo login welcome message.
touch $HOME/.sudo_as_admin_successful

# Change owner of sudo login disable file.
chown canvas:canvas $HOME/.sudo_as_admin_successful

# Fix current sudo bug for containers.
# https://github.com/sudo-project/sudo/issues/42
echo "Set disable_coredump false" >> /etc/sudo.conf


# Create Canvas settings directory.
mkdir -p $HOME/.canvas && chmod 777 -R $HOME/.canvas
chown canvas:canvas $HOME/.canvas


# Create directory for host home directory volume mounts.
#
# Flags:
#     -p: No error if existing, make parent directories as needed.
mkdir -p $HOME/host

# Change owner of volume directory.
chown canvas:canvas $HOME/host

# Create symbolic links to host configuration files.
#
# Flags:
#     -s: Make symbolic links instead of hard links.
ln -s $HOME/host/.aws $HOME/.aws
ln -s $HOME/host/.gitconfig $HOME/.gitconfig
ln -s $HOME/host/.ssh $HOME/.ssh

# Change owner of symbolic links.
#
# Flags:
#     -h: Affect symbolic links instead of any referenced file.
chown -h canvas:canvas \
    $HOME/.aws \
    $HOME/.gitconfig \
    $HOME/.ssh


# Update config store.
chown canvas:canvas -R /usr/local/config/configstore

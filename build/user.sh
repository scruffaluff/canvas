#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Create directory with open permissions and canvas owner.
#
# Arguments:
#     Directory path.
make_folder() {

    # Create directory and parent directories if necessary.
    mkdir -p "$1"

    # Allow all permissions for files in directory.
    chmod 777 -R "$1"

    # Change owner of directory and its files.
    chown canvas:canvas -R "$1"
}


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
make_folder $HOME/.canvas


# Create directory for host home directory volume mounts.
#
# Flags:
#     -p: No error if existing, make parent directories as needed.
make_folder $HOME/host

# Create symbolic links to host configuration files.
#
# Flags:
#     -s: Make symbolic links instead of hard links.
ln -s $HOME/host/.aws $HOME/.aws
ln -s $HOME/host/.config/gloud $HOME/.config/gcloud
ln -s $HOME/host/.gitconfig $HOME/.gitconfig
ln -s $HOME/host/.ssh $HOME/.ssh

# Change owner of symbolic links.
#
# Flags:
#     -h: Affect symbolic links instead of any referenced file.
chown -h canvas:canvas \
    $HOME/.aws \
    $HOME/host/.config/gloud \
    $HOME/.gitconfig \
    $HOME/.ssh


# Setup user configurations.

# Create configuration directories.
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/fish/functions"
mkdir -p "$HOME/.local/share/code-server/User"

# Install Fast NVM Fish if NVM is installed.
#
# Flags:
#     -c: Read commands from the command string operand.
#     -L: Follow redirect request.
#     -S: Show errors.
#     -f: Fail silently on server errors.
#     -x: Check if execute permission is granted.
if [ -x "$(command -v nvm)" ]; then
    curl -LSfs https://raw.githubusercontent.com/brigand/fast-nvm-fish/master/nvm.fish \
        > "$HOME/.config/fish/functions/nvm.fish"
fi

# Change owner and permissions of configuration files.
chmod 777 -R "$HOME/.config"
chown canvas:canvas -R "$HOME/.config"

# Change owner and permissions of local files.
chmod 777 -R "$HOME/.local"
chown canvas:canvas -R "$HOME/.local"

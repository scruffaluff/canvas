
#!/bin/bash
set -e


# Create non-priviledged user.
#
# Flags:
#     -l: Do not add user to lastlog database.
#     -m: Create user home directory if it does not exist.
#     -s /bin/zsh: Set user login shell to Bash.
#     -u 1000: Give new user UID value 1000.
useradd -lm -s /bin/zsh -u 1000 canvas


### Sudo ###

# Inst
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


# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
# mkdir -p $HOME/.local/share/fonts
# https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

POWERLEVEL9K_MODE="awesome-patched"

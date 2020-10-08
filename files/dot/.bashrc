# Bash settings file for non-login shells.


# Aliases.

# Load aliases if file exists.
#
# Flags:
#     -f: Check if file exists and is a regular file.
if [ -f "$HOME/.aliases" ]; then
    source "$HOME/.aliases"
fi


# User settings.

# Add scripts directory to PATH environment variable.
export PATH="$HOME/.local/bin:$PATH"


# Bash settings

# Load Bash completion if it exists.
#
# Bash completion file is not executable but can be sourced.
#
# Flags:
#     -f: Check if file exists and is a regular file.
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# Go settings.
export GOPATH="/usr/local/go"
export PATH="$GOPATH/bin:$PATH"


# Python settings.

# Make Poetry create virutal environments inside projects.
export POETRY_VIRTUALENVS_IN_PROJECT=1

# Add Pyenv binaries to system path.
export PYENV_ROOT="/usr/local/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize Pyenv if available.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # Load Pyenv completions.
    source "$(pyenv root)/completions/pyenv.bash"
fi


# Rust settings.
export CARGO_HOME="/usr/local/cargo"
export RUSTUP_HOME="/usr/local/rustup"
export PATH="$CARGO_HOME/bin:$PATH"


# Starship settings.

# Initialize Starship if available.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x "$(command -v starship)" ]; then
    eval "$(starship init bash)"
fi


# Tool settings.
export BAT_THEME="Solarized (light)"
complete -C /usr/local/bin/terraform terraform

# Initialize Zoxide if available.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x "$(command -v zoxide)" ]; then
    eval "$(zoxide init bash)"
fi


# TypeScript settings.

# Add NPM global binaries to system path.
export PATH="$HOME/.npm-global/bin:$PATH"

# Set Node version manager location.
export NVM_DIR="/usr/local/nvm"

# Load Node version manager and its bash completion.
#
# Flags:
#     -f: Check if file exists and is a regular file.
if [ -f "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh" 
fi
if [ -f "$NVM_DIR/bash_completion" ]; then
    source "$NVM_DIR/bash_completion"
fi

# Deno settings.
export DENO_INSTALL="/usr/local/deno"
export PATH="$DENO_INSTALL/bin:$PATH"


# Wasmtime settings.
export WASMTIME_HOME="/usr/local/wasmtime"
export PATH="$WASMTIME_HOME/bin:$PATH"

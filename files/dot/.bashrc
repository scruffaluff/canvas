# User settings.
# Add scripts directory to PATH environment variable.
export PATH="$HOME/.local/bin:$PATH"


# Node settings.
# Load Node version manager and its bash completion.
#
# Flags:
#     -s: Check if file exists and has size greater than zero.
export NVM_DIR="/usr/local/nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh" 
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
    source "$NVM_DIR/bash_completion"
fi
export PATH="$HOME/.npm-global/bin:$PATH"


# Python settings.
# Set Pyenv root location.
export PYENV_ROOT=/usr/local/pyenv
# Add pyenv executables and shims to PATH environment variable.
export PATH="$PYENV_ROOT/bin:$PATH"
# Make Poetry create virutal environments inside projects.
export POETRY_VIRTUALENVS_IN_PROJECT=1
# Initialize pyenv if installed.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
# Load Pyenv completions.
source $(pyenv root)/completions/pyenv.bash


# Rust settings.
export PATH="$HOME/.cargo/bin:$PATH"

# Wasmtime settings.
export WASMTIME_HOME="$/usr/local/.wasmtime"
export PATH="$WASMTIME_HOME/bin:$PATH"

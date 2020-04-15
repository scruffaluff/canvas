# User settings.
# Add scripts directory to PATH environment variable.
export PATH="$HOME/.local/bin:$PATH"


# Node settings.
# Load Node version manager and its bash completion.
#
# Flags:
#     -s: Check if file exists and has size greater than zero.
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh" 
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
    source "$NVM_DIR/bash_completion"
fi
export PATH="$HOME/.npm-global/bin:$PATH"


# Python settings.
# Add pyenv executables and shims to PATH environment variable.
export PATH="/usr/local/pyenv/bin:$PATH"
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


# Rust settings.
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.wasmtime/bin:$PATH"

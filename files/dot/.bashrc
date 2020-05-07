# User settings.
# Add scripts directory to PATH environment variable.
export PATH="$HOME/.local/bin:$PATH"


# Go settings.
export PATH="/usr/local/go/bin:$PATH"


# Node settings.
# Load Node version manager and its bash completion.
#
# Flags:
#     -s: Check if file exists and has size greater than zero.
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh" 
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
    source "$NVM_DIR/bash_completion"
fi
export PATH="$HOME/.npm-global/bin:$PATH"


# Python settings.
# Make Poetry create virutal environments inside projects.
export POETRY_VIRTUALENVS_IN_PROJECT=1
# Initialize pyenv if installed.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # Load Pyenv completions.
    source $(pyenv root)/completions/pyenv.bash
fi


# Rust settings.
export PATH="usr/local/cargo/bin:$PATH"


# Tool settings.
export BAT_THEME="Solarized (light)"
complete -C /usr/local/bin/terraform terraform


# Wasmtime settings.
export PATH="$WASMTIME_HOME/bin:$PATH"


# Starship settings.
eval "$(starship init bash)"

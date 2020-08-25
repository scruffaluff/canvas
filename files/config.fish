# Fish settings file.


# Aliases.
source "$HOME/.aliases"


# User settings.
# Add scripts directory to PATH environment variable.
set -x PATH "$HOME/.local/bin:$PATH"


# Go settings.
set -x PATH "/usr/local/go/bin:$PATH"


# Node settings.
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
set -x PATH "$HOME/.npm-global/bin:$PATH"

# Deno settings.
set -x DENO_INSTALL "/usr/local/deno"
set -x PATH "$DENO_INSTALL/bin:$PATH"


# Python settings.
# Make Poetry create virutal environments inside projects.
set -x POETRY_VIRTUALENVS_IN_PROJECT 1

# Initialize pyenv if installed.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x "$(command -v pyenv)" ]; then
    pyenv init - | source
    pyenv virtualenv-init - | source
fi


# Rust settings.
set -x PATH "usr/local/cargo/bin:$PATH"


# Tool settings.
set -x BAT_THEME "Solarized (light)"
eval "$(zoxide init bash)"


# Wasmtime settings.
set -x PATH "$WASMTIME_HOME/bin:$PATH"


# Starship settings.
starship init fish | source

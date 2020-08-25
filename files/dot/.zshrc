# Zsh settings file for non-login shells.


# Zsh initialization settings.

# Set case-sensitive auto-completion.
CASE_SENSITIVE="true"

# Load Oh My Zsh configurations.
source "$ZSH/oh-my-zsh.sh"


# Load aliases.
source "$HOME/.aliases"


# User settings.

# Add scripts directory to PATH environment variable.
export PATH="$HOME/.local/bin:$PATH"


# Go settings.
export PATH="/usr/local/go/bin:$PATH"


# Node settings.

# Load Node version manager.
#
# Flags:
#     -s: Check if file exists and has size greater than zero.
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh" 
fi
export PATH="$HOME/.npm-global/bin:$PATH"

# Deno settings.
export DENO_INSTALL="/usr/local/deno"
export PATH="$DENO_INSTALL/bin:$PATH"


# Python settings.

# Add pyenv executables and shims to PATH environment variable.
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv if installed.
#
# Flags:
#     -x: Check if execute permission is granted.
if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # Load Pyenv completions.
    source $(pyenv root)/completions/pyenv.zsh
fi


# Rust settings.
export PATH="$CARGO_HOME/bin:$PATH"


# Tool settings.
export BAT_THEME="Solarized (light)"


# Wasmtime settings.
export PATH="$WASMTIME_HOME/bin:$PATH"


# Starship settings.
eval "$(starship init zsh)"

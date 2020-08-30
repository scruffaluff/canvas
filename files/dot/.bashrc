# Bash settings file for non-login shells.


# Aliases.
source "$HOME/.aliases"


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
export PATH="/usr/local/go/bin:$PATH"


# Google Cloud Platform settings.
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google-cloud-sdk/path.bash.inc' ]; then 
    source '/usr/local/google-cloud-sdk/path.bash.inc'
fi
# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/google-cloud-sdk/completion.bash.inc' ]; then 
    source '/usr/local/google-cloud-sdk/completion.bash.inc'
fi


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
export PATH="$HOME/.npm-global/bin:$PATH"

# Deno settings.
export DENO_INSTALL="/usr/local/deno"
export PATH="$DENO_INSTALL/bin:$PATH"


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
    source "$(pyenv root)/completions/pyenv.bash"
fi


# Rust settings.
export PATH="usr/local/cargo/bin:$PATH"


# Tool settings.
export BAT_THEME="Solarized (light)"
complete -C /usr/local/bin/terraform terraform
eval "$(zoxide init bash)"


# Wasmtime settings.
export PATH="$WASMTIME_HOME/bin:$PATH"


# Starship settings.
eval "$(starship init bash)"

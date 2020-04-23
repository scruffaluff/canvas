# Zsh Settings

# Enable Powerlevel10k instant prompt.
# Must be at top of file for fast loading.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# se case-sensitive auto-completion.
CASE_SENSITIVE="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# User settings.
# Add scripts directory to PATH environment variable.
export PATH="$HOME/.local/bin:$PATH"


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


# Wasmtime settings.
export PATH="$WASMTIME_HOME/bin:$PATH"

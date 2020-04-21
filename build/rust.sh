#!/bin/bash
set -e


# Install Rust if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$RUST_BUILD" ]; then
    printf "^^^^^ Rust build skipped.\n ^^^^^"
else
    printf "##### Rust build starting. #####\n"

    # Install buildpack-deps image dependencies.
    #
    # Flags:
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get install -qy --no-install-recommends \
        lldb \
        llvm

    # Install GdbGui
    # pipx install gdbgui
    
    # Install Rust.
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

    # Bash completion.
    # rustup completions bash > ~/.local/share/bash-completion/completions/rustup

    # Zsh completion.
    # rustup completions zsh > ~/.zfunc/_rustup

    # Chheck that cargo, rustc, and rustup were installed correctly.
    cargo --version
    rustc --version 
    rustup --version

    # Cargo components.
    rustup component add clippy
    rustup component add rustfmt
    rustup component add rls

    # Install Cargo packges.
    cargo install \
        cargo-edit \
        cargo-make \
        mdbook \
        nu \
        pyoxidizer

    # Esnure that all users can read and write to cargo files.
    #
    # Flags:
    #     -R: Apply modifications recursivley to a directory.
    #     a+rw: Give read and write permissions to all users.
    chmod -R a+rw $RUSTUP_HOME $CARGO_HOME;


    # Install Wasmtime
    mkdir $WASMTIME_HOME
    chmod a+rw $WASMTIME_HOME
    curl https://wasmtime.dev/install.sh -sSf | bash

    # Add WASM target.
    rustup target add wasm32-wasi
fi

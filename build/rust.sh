#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install Rust if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$rust_build" ]; then
    printf "^^^^^ Rust build skipped.\n ^^^^^"
else
    printf "##### Rust build starting. #####\n"

    # Install buildpack-deps image dependencies.
    #
    # Flags:
    #     -m: Ignore missing packages and handle result.
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get update -m && apt-get install -qy --no-install-recommends \
        clang \
        lld \
        lldb \
        llvm
    
    # Install Rust.
    #
    # Flags:
    #     -S: Show errors.
    #     -f: Fail silently on server errors.
    #     -s: (curl) Disable progress bars.
    #     -s: (sh) Read commands from standard input.
    #     -y: Disable confirmation prompt.
    #     --no-modify-path: Do not configure the PATH environment variable.
    curl -Sfs https://sh.rustup.rs | sh -s -- -y --no-modify-path

    # Check that cargo, rustc, and rustup were installed successfully.
    cargo --version
    rustc --version 
    rustup --version

    # Cargo components.
    rustup component add clippy
    rustup component add rustfmt

    # Add additional Rust toolchain targets.
    # Install WASM toolchain target.
    rustup target add wasm32-wasi

    # Install Cargo packges.
    cargo install \
        cargo-edit \
        cargo-generate \
        cargo-make \
        cargo-watch

    # Clear Cargo registry
    rm -fr /usr/local/cargo/registry

    # Esnure that all users can read and write to cargo files.
    #
    # Flags:
    #     -R: Apply modifications recursivley to a directory.
    #     777: Give read, write, and execute permissions to all users.
    chmod -R 777 $RUSTUP_HOME $CARGO_HOME;


    # Create Wasmtime parent directory.
    mkdir $WASMTIME_HOME

    # Install Wasmtime.
    #
    # Flags:
    #     -S: Show errors.
    #     -f: Fail silently on server errors.
    #     -s: (curl) Disable progress bars.
    curl -Sfs https://wasmtime.dev/install.sh | bash

    # Esnure that all users can read and write to Wasmtime files.
    #
    # Flags:
    #     -R: Apply modifications recursivley to a directory.
    #     777: Give read, write, and execute permissions to all users.
    chmod -R 777 $WASMTIME_HOME
fi

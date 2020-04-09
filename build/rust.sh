#!/bin/bash
set -e


# Install Rust if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$RUST_BUILD" ]; then
    printf "^^^^^ Rust build skipped.\n ^^^^^"
else
    printf "##### Rust build starting. #####\n"
    
    # Install Rust and update compiler.
    #
    # Flags:
    #     -L: Follow redirect if requested from endpoint.
    #     -S: Show error message if curl request fails.
    #     -s: Silent mode, i.e. do not show progress bar.
    curl -LSs https://sh.rustup.rs | sh -s -- -y \
        && rustup update

    # Install Cargo packges.
    cargo install \
        cargo-edit \
        mdbook \
        nu \
        pyoxidizer
fi

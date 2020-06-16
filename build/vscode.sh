#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install VSCode if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$vscode_build" ]; then
    printf "^^^^^ VSCode build skipped. ^^^^^\n"
else
    printf "##### VSCode build starting. #####\n"

    # Install Coder.
    curl -LSfs https://code-server.dev/install.sh | sh -s -- --prefix=/usr/local

    code-server --install-extension bungcip.better-toml
    code-server --install-extension coenraads.bracket-pair-colorizer-2
    code-server --install-extension eamodio.gitlens
    code-server --install-extension esbenp.prettier-vscode
    code-server --install-extension james-yu.latex-workshop
    code-server --install-extension ms-dotnettools.csharp
    code-server --install-extension ms-python.python
    code-server --install-extension ms-vscode.cpptools
    code-server --install-extension ritwickdey.liveserver
    code-server --install-extension rust-lang.rust
    code-server --install-extension stkb.rewrap
    code-server --install-extension vadimcn.vscode-lldb
    code-server --install-extension yzhang.markdown-all-in-one

    chmod 777 -R /usr/local/code-server
fi

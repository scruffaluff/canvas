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

    # Source NVM configuration.
    . $NVM_DIR/nvm.sh

    # Install Yarn.
    nvm use 10
    npm install -g yarn

    # Build Theia IDE and download extensions.
    # Theia extensions can be found at https://open-vsx.org/.
    cd /usr/local/theia
    yarn
    yarn theia build
    yarn download

    # Make Theia configuration directory.
    mkdir -p $HOME/.theia


    # Install Coder.
    curl -LSfs https://code-server.dev/install.sh | sh -s -- --prefix=/usr/local

    # If the XDG_DATA_HOME environment variable is set the data directory will 
    # be $XDG_DATA_HOME/code-server/extensions. In general we try to follow the 
    # XDG directory spec.
    code-server --install-extension \
        coenraads.bracket-pair-colorizer-2 \
        eamodio.gitlens \
        esbenp.prettier-vscode \
        james-yu.latex-workshop \
        ms-dotnettools.csharp \
        ms-python.python \
        ms-vscode.cpptools \
        ritwickdey.liveserver \
        rust-lang.rust \
        stkb.rewrap \
        vadimcn.vscode-lldb \
        yzhang.markdown-all-in-one
fi

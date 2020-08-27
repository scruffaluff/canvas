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

    # Install Code Server.
    #
    # Flags:
    #     -L: Follow redirect request.
    #     -S: Show errors.
    #     -f: Fail silently on server errors.
    #     -s: Disable progress bars.
    curl -LSfs https://code-server.dev/install.sh | sh -s -- --prefix=/usr/local

    # Install VSCode extensions.
    code-server --install-extension bungcip.better-toml
    code-server --install-extension coenraads.bracket-pair-colorizer-2
    code-server --install-extension eamodio.gitlens
    code-server --install-extension esbenp.prettier-vscode
    code-server --install-extension james-yu.latex-workshop
    code-server --install-extension matklad.rust-analyzer
    code-server --install-extension ms-dotnettools.csharp
    code-server --install-extension ms-python.python
    code-server --install-extension ms-vscode.cpptools
    code-server --install-extension octref.vetur
    code-server --install-extension ritwickdey.liveserver
    code-server --install-extension skyapps.fish-vscode
    code-server --install-extension stkb.rewrap
    code-server --install-extension tabnine.tabnine-vscode
    code-server --install-extension vadimcn.vscode-lldb
    code-server --install-extension vscode-icons-team.vscode-icons
    code-server --install-extension yzhang.markdown-all-in-one

    # Esnure that all users can read and write to code server files.
    #
    # Flags:
    #     -R: Apply modifications recursivley to a directory.
    #     777: Give read, write, and execute permissions to all users.
    chmod 777 -R /usr/local/code-server
fi

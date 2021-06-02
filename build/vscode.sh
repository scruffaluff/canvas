#!/bin/bash
# Exit immediately if a command exists with a non-zero status.
set -e


# Install VSCode if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "${vscode_build}" ]; then
  printf "^^^^^ VSCode build skipped. ^^^^^\n"
else
  printf "##### VSCode build starting. #####\n"

  # Create non-priviledged user.
  #
  # Flags:
  #     -l: Do not add user to lastlog database.
  #     -m: Create user home directory if it does not exist.
  #     -s /usr/bin/fish: Set user login shell to Fish.
  #     -u 1000: Give new user UID value 1000.
  if ! id canvas &> "/dev/null" ; then
      useradd -lm -s "/usr/bin/fish" -u 1000 canvas
  fi

  # Install sudo.
  apt-get update && apt-get install -y sudo

  # Set USER for Code Server installation.
  #
  # On line 85 the Code Server installation shell script attempts to print a
  # helpful message to the user. As a result, the script will fail if the
  # user is not set.
  export USER=canvas

  # Install Code Server.
  #
  # Flags:
  #     -L: Follow redirect request.
  #     -S: Show errors.
  #     -f: Fail silently on server errors.
  #     -s: Disable progress bars.
  curl -LSfs "https://code-server.dev/install.sh" | sh -s -- --prefix=/usr/local

  # Esnure that all users can read and write to code server files.
  #
  # Flags:
  #     -R: Apply modifications recursivley to a directory.
  #     -p: Make parent directories as needed and do not error if existing.
  #     777: Give read, write, and execute permissions to all users.
  mkdir -p "/usr/local/code-server"
  chmod 777 -R "/usr/local/code-server"

  # Install VSCode extensions as canvas user.
  #
  # Flags:
  #     -H: Set HOME environment variable to user's home directory.
  #     -i: Run command with user's login shell.
  #     -u canvas: Run command as canvas user.
  sudo -Hi -u canvas bash << EOF
    code-server --install-extension bungcip.better-toml
    code-server --install-extension coenraads.bracket-pair-colorizer-2
    code-server --install-extension eamodio.gitlens
    code-server --install-extension esbenp.prettier-vscode
    code-server --install-extension james-yu.latex-workshop
    code-server --install-extension jroesch.lean
    code-server --install-extension matklad.rust-analyzer
    code-server --install-extension ms-dotnettools.csharp
    code-server --install-extension ms-python.python
    code-server --install-extension octref.vetur
    code-server --install-extension ritwickdey.liveserver
    code-server --install-extension ryanluker.vscode-coverage-gutters
    code-server --install-extension skyapps.fish-vscode
    code-server --install-extension stkb.rewrap
    code-server --install-extension tabnine.tabnine-vscode
    code-server --install-extension vadimcn.vscode-lldb
    code-server --install-extension vscode-icons-team.vscode-icons
    code-server --install-extension yzhang.markdown-all-in-one
EOF
fi

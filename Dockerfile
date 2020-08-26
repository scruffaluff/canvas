FROM buildpack-deps:20.04


### Build Arguments ###

ARG cpp_build
ARG csharp_build
ARG go_build
ARG haskell_build
ARG python_build
ARG rust_build
ARG slim_build
ARG typescript_build
ARG vscode_build


### System ###

# Set system language settings.
ENV \
    # Avoid warnings by switching to noninteractive.
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=America/Los_Angeles \
    XDG_CONFIG_HOME=/usr/local/config

# Copy system configuration files.
COPY ./files/init.vim /usr/local/nvim/

COPY ./build/system.sh /tmp/system.sh
RUN chmod 755 /tmp/system.sh \
    && /tmp/system.sh \
    && rm -rf /tmp/*


### C# ###

# Copy C# build script and execute.
COPY ./build/csharp.sh /tmp/csharp.sh 
RUN chmod 755 /tmp/csharp.sh \
    && /tmp/csharp.sh $csharp_build \
    && rm -rf /tmp/*


### C++ ###

# Copy C++ build script and execute.
COPY ./build/cpp.sh /tmp/cpp.sh 
RUN chmod 755 /tmp/cpp.sh \
    && /tmp/cpp.sh $cpp_build \
    && rm -rf /tmp/*


### Go ###

# Add Go binaries to PATH.
ENV PATH=/usr/local/go/bin:$PATH

# Copy Go build script and execute.
COPY ./build/go.sh /tmp/go.sh 
RUN chmod 755 /tmp/go.sh \
    && /tmp/go.sh $go_build \
    && rm -rf /tmp/*


### Haskell ###

# Copy Haskell build script and execute.
COPY ./build/haskell.sh /tmp/haskell.sh 
RUN chmod 755 /tmp/haskell.sh \
    && /tmp/haskell.sh $haskell_build \
    && rm -rf /tmp/*


### Python ###

ENV \
    # Make Poetry create virutal environments inside projects.
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    PYENV_ROOT=/usr/local/pyenv
# Require separate ENV statement to use defined environment variables.
# Add Pyenv and Python binaries to PATH.
ENV PATH=$PYENV_ROOT/bin:$PATH

# Copy Python build script and execute.
COPY ./build/python.sh /tmp/python.sh 
RUN chmod 755 /tmp/python.sh \
    && /tmp/python.sh $python_build \
    && rm -rf /tmp/*


### Rust ###

ENV \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    WASMTIME_HOME=/usr/local/wasmtime
# Add Cargo and Wastime binaries to PATH.
ENV PATH=$CARGO_HOME/bin:$WASMTIME_HOME/bin:$PATH

# Copy Rust build script and execute.
COPY ./build/rust.sh /tmp/rust.sh 
RUN chmod 755 /tmp/rust.sh \
    && /tmp/rust.sh $rust_build \
    && rm -rf /tmp/*


### TypeScript ###

ENV \
    DENO_INSTALL=/usr/local/deno \
    # Set Node version manager location.
    NVM_DIR=/usr/local/nvm

# Copy TypeScript build script and execute.
COPY ./build/typescript.sh /tmp/typescript.sh 
RUN chmod 755 /tmp/typescript.sh \
    && /tmp/typescript.sh $typescript_build \
    && rm -rf /tmp/*


### VSCode ###

ENV \
    CODE_SERVER_CONFIG=/usr/local/code-server/config.yaml

# Copy Code Server configuration files.
COPY ./files/vscode/keybindings.json $XDG_DATA_HOME/code-server/User/
COPY ./files/vscode/settings.json $XDG_DATA_HOME/code-server/User/

# Copy VSCode build script and execute.
COPY ./build/vscode.sh /tmp/vscode.sh 
RUN chmod 755 /tmp/vscode.sh \
    && /tmp/vscode.sh $vscode_build \
    && rm -rf /tmp/*


### User ###

ENV \
    HOME=/home/canvas

COPY ./build/user.sh /tmp/user.sh
RUN chmod 755 /tmp/user.sh \
    && /tmp/user.sh \
    && rm -rf /tmp/*

USER canvas
WORKDIR $HOME
VOLUME $HOME/host


### Configuration Files ###

# Copy dot files.
COPY --chown=canvas:canvas ./files/dot/ $HOME/

# Copy Fish settings file.
COPY --chown=canvas:canvas ./files/config.fish $XDG_CONFIG_HOME/fish/config.fish

# Copy entrypoint script and make executable.
COPY --chown=canvas:canvas ./files/entrypoint.sh $HOME/.canvas/
RUN chmod 755 $HOME/.canvas/entrypoint.sh


ENTRYPOINT ["/usr/local/bin/fixuid", "/home/canvas/.canvas/entrypoint.sh"]
CMD ["/bin/bash"]

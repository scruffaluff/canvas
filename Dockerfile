FROM buildpack-deps:20.04


### Build Arguments ###

ARG cpp_build
ARG go_build
ARG haskell_build
ARG python_build
ARG rust_build
ARG slim_build
ARG typescript_build


### System ###

# Set system language settings.
ENV \
    # Avoid warnings by switching to noninteractive.
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=America/Los_Angeles

COPY ./build/system.sh /tmp/system.sh
RUN chmod 755 /tmp/system.sh \
    && /tmp/system.sh \
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
    # Set Node version manager location.
    NVM_DIR=/usr/local/nvm

# Copy TypeScript build script and execute.
COPY ./build/typescript.sh /tmp/typescript.sh 
RUN chmod 755 /tmp/typescript.sh \
    && /tmp/typescript.sh $typescript_build \
    && rm -rf /tmp/*


### User ###

ENV \
    HOME=/home/canvas
# Configure ZSH environment variables.
ENV ZSH=$HOME/.oh-my-zsh \
    ZSH_CUSTOM=$HOME/.oh-my-zsh/custom \
    ZSH_THEME=powerlevel10k/powerlevel10k

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


ENTRYPOINT ["fixuid"]

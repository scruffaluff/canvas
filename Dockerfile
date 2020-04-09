FROM ubuntu:19.10


### Build Arguments ###

ARG CPP_BUILD
ARG GO_BUILD
ARG HASKELL_BUILD
ARG PYTHON_BUILD
ARG RUST_BUILD
ARG SLIM_BUILD
ARG TYPESCRIPT_BUILD


ENV \
    HOME=/home/canvas \
    STD_USER=canvas


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
        $CPP_BUILD \
        $GO_BUILD \
        $HASKELL_BUILD \
        $PYTHON_BUILD \
        $RUST_BUILD \
        $TYPESCRIPT_BUILD \
    && rm -rf /tmp/*


### User ###

COPY ./build/user.sh /tmp/user.sh
RUN chmod 755 /tmp/user.sh \
    && /tmp/user.sh \
    && rm -rf /tmp/*

USER canvas
WORKDIR $HOME
VOLUME $HOME/host


### C++ ###

# Copy C++ build script and execute.
COPY --chown=canvas:canvas ./build/cpp.sh $HOME/tmp/cpp.sh 
RUN chmod 755 $HOME/tmp/cpp.sh \
    && $HOME/tmp/cpp.sh $CPP_BUILD \
    && rm -rf $HOME/tmp/*


### Go ###

# Copy Go build script and execute.
COPY --chown=canvas:canvas ./build/go.sh $HOME/tmp/go.sh 
RUN chmod 755 $HOME/tmp/go.sh \
    && $HOME/tmp/go.sh $GO_BUILD \
    && rm -rf $HOME/tmp/*


### Haskell ###

# Copy Haskell build script and execute.
COPY --chown=canvas:canvas ./build/haskell.sh $HOME/tmp/haskell.sh 
RUN chmod 755 $HOME/tmp/haskell.sh \
    && $HOME/tmp/haskell.sh $HASKELL_BUILD \
    && rm -rf $HOME/tmp/*


### Python ###

ENV \
    # Speed up Pyenv builds.
    CFLAGS="-O2" \
    # Add Pyenv binaries, Pyenv shims, and Pipx binaries to PATH.
    PATH=$HOME/.pyenv/bin:$HOME/.pyenv/shims:$HOME/.local/bin:$PATH \
    # Make Poetry create virutal environments inside projects.
    POETRY_VIRTUALENVS_IN_PROJECT=1

# Copy Python build script and execute.
COPY --chown=canvas:canvas ./build/python.sh $HOME/tmp/python.sh 
RUN chmod 755 $HOME/tmp/python.sh \
    && $HOME/tmp/python.sh $PYTHON_BUILD \
    && rm -rf $HOME/tmp/*


### Rust ###

# Add Cargo binaries to PATH.
ENV \
    PATH=$HOME/.cargo/bin:$PATH

# Copy Rust build script and execute.
COPY --chown=canvas:canvas ./build/rust.sh $HOME/tmp/rust.sh 
RUN chmod 755 $HOME/tmp/rust.sh \
    && $HOME/tmp/rust.sh $RUST_BUILD \
    && rm -rf $HOME/tmp/*


### TypeScript ###

ENV \
    # Set Node version manager location.
    NVM_DIR=$HOME/.nvm \
    # Add NPM binaries to PATH.
    PATH=$HOME/.npm-global/bin:$PATH

# Copy TypeScript build script and execute.
COPY --chown=canvas:canvas ./build/typescript.sh $HOME/tmp/typescript.sh 
RUN chmod 755 $HOME/tmp/typescript.sh \
    && $HOME/tmp/typescript.sh $TYPESCRIPT_BUILD \
    && rm -rf $HOME/tmp/*


### Configuration Files ###

# Copy dot files.
COPY --chown=canvas:canvas ./files/dot/ $HOME/


### Clean ###

RUN rm -rf $HOME/tmp


ENTRYPOINT ["fixuid"]

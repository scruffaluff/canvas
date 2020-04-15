#!/bin/bash
set -e

# This is just for indicating that commands' results are being
# intentionally ignored. Usually, because it's being executed
# as part of error handling.
install_python() {
    PYTHON_VERSION="$1"
    PYVER=$(grep -Po "\d+\.\d+" <<< $PYTHON_VERSION)

    # Install Python with instructions from
    # https://github.com/docker-library/python/blob/master/Dockerfile-debian.template


    curl https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz -o python.tar.xz
    mkdir -p /usr/src/python
    tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz
    rm python.tar.xz

    cd /usr/src/python
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"

    ./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--enable-shared \
        --with-pydebug \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip

    # Flags:
    #     -j: Number of simultaneous jobs. nproc is number of processors on system.
    #     -s: Show only warnings and errors
    make -s -j "$(nproc)"

    # Alter
    make altinstall

    # Configure dynamic linker run time bindings for Python.
    ldconfig

    # Remove build directory.
    # find /usr/local -depth \
	# 	\( \
	# 		\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
	# 		-o \
	# 		\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
	# 	\) -exec rm -rf '{}' +

    rm -rf /usr/src/python

    # Check that Python was installed properly.
    python$PYVER --version

    # Install pip with instructions from https://github.com/pypa/get-pip.
    curl https://bootstrap.pypa.io/get-pip.py | python3.8

    # Check that pip was installed correctly.
    python$PYVER -m pip --version
}


# Install Python if requested.
# Flags:
#     -z: True if the string is null.
if [ -z "$PYTHON_BUILD" ]; then
    printf "^^^^^ Python build skipped. ^^^^^\n"
else
    printf "##### Python build starting. #####\n"

    # Install Python recommend dependencies
    #
    # Flags:
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get update && apt-get install -y --no-install-recommends \
		libbluetooth-dev \
		tk-dev \
		uuid-dev
    
    # Install ONNX required utilites.
    # https://github.com/pyenv/pyenv/wiki/Common-build-problems#prerequisites
    #
    # Flags:
    #     -q: Produce log suitable output by omitting progress indicators.
    #     -y: Assume "yes" as answer to all prompts and run non-interactively.
    #     --no-install-recommends: Do not install recommended packages.
    apt-get install -qy --no-install-recommends \
        cmake \
        protobuf-compiler

    install_python 3.8.2
fi

#!/bin/bash


# Find latest patch release for a Python version prefix.
#
# Arguments:
#     Python version prefix.
pyenv_version() {
    echo $(pyenv install --list | grep -E "^\s+$1.[0-9]+$" | tail -1)
}

prefixes=("3.9" "3.8" "3.7" "3.6")
versions=()
for prefix in ${prefixes[@]}; do
    versions+="$(pyenv_version $prefix) "
done

for version in ${versions[@]}; do
    echo $version
    echo ${version//./ }
done
wait

echo "pyenv ${versions[@]}"

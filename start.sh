#!/usr/bin/env bash

function lowercase() {
    echo "$1" | awk '{print tolower($0)}'
}

function edit_cargo_toml() {
    local git_username
    git_username="$(git config --get user.name)"
    local git_email
    git_email="$(git config --get user.email)"

    sed -i.bk "s/^name = \"package-name\"/name = \"${PROJECT_NAME}\"/" Cargo.toml
    sed -i.bk "s/^name = \"lib_name\"/name = \"${LIB_NAME}\"/" Cargo.toml
    sed -i.bk "s/^authors = \[\"username \<email\>\"\]/authors = [\"${git_username} <${git_email}>\"]/" Cargo.toml
    rm Cargo.toml.bk
}

function edit_makefile() {
    sed -i.bk "s/^LIB = lib_name.wasm/LIB = ${LIB_NAME}.wasm/" Makefile
    rm Makefile.bk
}

# Read the project name
printf "%s\n" "Name of the project:"
read -r PROJECT_NAME

# Modify PROJECT_NAME for usage inside Cargo.toml and Makefile
# - lowercase, "-" delimited name
# - snake-case name(for lib and Makefile)
PROJECT_NAME=$(lowercase "${PROJECT_NAME//_/-}")
LIB_NAME="${PROJECT_NAME//-/_}"
printf "\n%s\n%s\n\n" "Project name: ${PROJECT_NAME}" "Library name: ${LIB_NAME}"

# Edit Cargo.toml:
# - set package.name
# - set package.authors
# - set lib.name
edit_cargo_toml

# Edit Makefile
edit_makefile

# Install dependencies
printf "%s\n" "Adding wasm32-unknown-unknown as a compile target"
rustup target add wasm32-unknown-unknown
printf "%s\n" "Installing wasm-bindgen-cli with cargo"
cargo install wasm-bindgen-cli

# Ask if LICENSE should be removed
read -p "Delete LICENSE? [Y/n]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm LICENSE
fi

# Ask if .git should be removed
read -p "Delete the git repository(the .git folder)? [Y/n]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf .git
fi

# Ask if a new git repository should be initialized
read -p "Create a new git repository? [Y/n]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git init
fi

# Remove start.sh
rm start.sh

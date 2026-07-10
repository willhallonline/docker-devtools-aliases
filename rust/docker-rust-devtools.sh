# Rust DevTools
#
# Aliases for the Rust toolchain, run inside Docker containers. This file is
# NOT sourced automatically — add it explicitly if you need it:
#
#   source ~/.docker-devtools/docker-devtools.sh
#   source ~/.docker-devtools/rust/docker-rust-devtools.sh

# Cargo — Rust build tool & package manager (official image)
# usage: cargo-docker build / test / run
alias cargo-docker="docker_alias /app rust:alpine cargo"
alias rust-bash-docker="docker_alias /app rust:alpine /bin/sh"

# rustfmt — Rust code formatter (ships with the official image) — usage: rustfmt-docker src/main.rs
alias rustfmt-docker="docker_alias /app rust:alpine rustfmt"

# Clippy — Rust linter (ships with the official image) — usage: clippy-docker
alias clippy-docker="docker_alias /app rust:alpine cargo clippy"

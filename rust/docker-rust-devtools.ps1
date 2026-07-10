# Docker DevTools — Rust (PowerShell)
# Not sourced automatically; source explicitly if needed:
#   . "$HOME/.docker-devtools/rust/docker-rust-devtools.ps1"

# Cargo — Rust build tool & package manager (official image)
# usage: cargo-docker build / test / run
function cargo-docker { Invoke-DockerAlias /app rust:alpine cargo @args }
function rust-bash-docker { Invoke-DockerAlias /app rust:alpine /bin/sh @args }

# rustfmt — Rust code formatter (ships with the official image) — usage: rustfmt-docker src/main.rs
function rustfmt-docker { Invoke-DockerAlias /app rust:alpine rustfmt @args }

# Clippy — Rust linter (ships with the official image) — usage: clippy-docker
function clippy-docker { Invoke-DockerAlias /app rust:alpine cargo clippy @args }

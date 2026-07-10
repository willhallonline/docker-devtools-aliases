# Docker DevTools — Go (PowerShell)
# Not sourced automatically; source explicitly if needed:
#   . "$HOME/.docker-devtools/go/docker-go-devtools.ps1"

# Go (official image) — usage: go-docker run main.go / go-docker build ./...
function go-docker { Invoke-DockerAlias /app golang:alpine go @args }
function go-bash-docker { Invoke-DockerAlias /app golang:alpine /bin/sh @args }

# gofmt — Go formatter (ships with the official image) — usage: gofmt-docker -l -w .
function gofmt-docker { Invoke-DockerAlias /app golang:alpine gofmt @args }

# golangci-lint — Go meta-linter (official image) — usage: golangci-lint-docker run ./...
function golangci-lint-docker { Invoke-DockerAlias /app golangci/golangci-lint:latest golangci-lint @args }

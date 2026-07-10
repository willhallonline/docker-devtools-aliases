# Go DevTools
#
# Aliases for the Go toolchain, run inside Docker containers. This file is
# NOT sourced automatically — add it explicitly if you need it:
#
#   source ~/.docker-devtools/docker-devtools.sh
#   source ~/.docker-devtools/go/docker-go-devtools.sh

# Go (official image) — usage: go-docker run main.go / go-docker build ./...
alias go-docker="docker_alias /app golang:alpine go"
alias go-bash-docker="docker_alias /app golang:alpine /bin/sh"

# gofmt — Go formatter (ships with the official image) — usage: gofmt-docker -l -w .
alias gofmt-docker="docker_alias /app golang:alpine gofmt"

# golangci-lint — Go meta-linter (official image) — usage: golangci-lint-docker run ./...
alias golangci-lint-docker="docker_alias /app golangci/golangci-lint:latest golangci-lint"

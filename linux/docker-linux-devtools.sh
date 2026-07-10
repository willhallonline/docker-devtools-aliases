# Linux DevTools
#
# Aliases for common Linux command-line utilities, run inside Docker
# containers. This file is NOT sourced automatically — add it explicitly if
# you need it:
#
#   source ~/.docker-devtools/docker-devtools.sh
#   source ~/.docker-devtools/linux/docker-linux-devtools.sh

# A few of these tools (ripgrep, tmux, fd) have no official pre-built image,
# so this helper installs the requested apk package into an ephemeral
# alpine:latest container on every run, then execs the binary. Trade-off is a
# couple of extra seconds per invocation in exchange for not needing a custom
# image build.
# Usage: _apk_cli_alias <alias-name> <apk-package> [binary-name]
_apk_cli_alias() {
    local name="$1" package="$2" binary="${3:-$2}"
    # shellcheck disable=SC2016
    alias "${name}"="docker_alias /app alpine:latest sh -c 'apk add --no-cache --quiet \"${package}\" 1>&2 && exec ${binary} \"\$@\"' --"
}

# yamllint — YAML linter — usage: yamllint-docker file.yml
alias yamllint-docker="docker_alias /app cytopia/yamllint:latest yamllint"

# ShellCheck — static analysis/linter for shell scripts (official image)
# usage: shellcheck-docker script.sh
alias shellcheck-docker="docker_alias /mnt koalaman/shellcheck:stable"

# shfmt (bashfmt) — shell script formatter (official image)
# usage: shfmt-docker -l -w script.sh
alias shfmt-docker="docker_alias /app mvdan/shfmt:latest"

# nmap — network discovery and security auditing — usage: nmap-docker -A -T4 scanme.nmap.org
alias nmap-docker="docker_alias /app instrumentisto/nmap:latest"

# jq — command-line JSON processor (official image) — usage: jq-docker '.' file.json
alias jq-docker="docker_alias /app ghcr.io/jqlang/jq:latest"

# ripgrep — fast recursive grep alternative — usage: rg-docker "TODO"
_apk_cli_alias rg-docker ripgrep rg

# tmux — terminal multiplexer — usage: tmux-docker new -s work
_apk_cli_alias tmux-docker tmux tmux

# fd — fast, user-friendly alternative to find — usage: fd-docker "\.log$"
_apk_cli_alias fd-docker fd fd

# rsync — fast incremental file transfer/sync — usage: rsync-docker -av src/ dest/
alias rsync-docker="docker_alias /app instrumentisto/rsync-ssh:latest rsync"

# rclone — sync/manage files across cloud storage providers (official image)
# usage: rclone-docker ls remote:bucket
alias rclone-docker="docker_alias /app rclone/rclone:latest"

# watchdog — Python filesystem watcher, provides the `watchmedo` CLI to run
# shell commands on file changes. https://github.com/gorakhargosh/watchdog
# There is no official pre-built image, so it's pip-installed at runtime.
# usage: watchdog-docker shell-command --patterns="*.py" --command='pytest'
alias watchdog-docker="docker_alias /app python:3.13-slim sh -c 'pip install --quiet --no-cache-dir watchdog 1>&2 && exec watchmedo \"\$@\"' --"

# hadolint — Dockerfile linter (official image) — usage: hadolint-docker Dockerfile
alias hadolint-docker="docker_alias /app hadolint/hadolint:latest hadolint"

# markdownlint-cli — Markdown linter (community image) — usage: markdownlint-docker '**/*.md'
alias markdownlint-docker="docker_alias /app igorshubovych/markdownlint-cli:latest"

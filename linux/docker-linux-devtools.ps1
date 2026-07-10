# Docker DevTools — Linux tools (PowerShell)
# Not sourced automatically; source explicitly if needed:
#   . "$HOME/.docker-devtools/linux/docker-linux-devtools.ps1"
#
# NOTE on argument passing: PowerShell's parameter binder will try to match a
# bare "-x" token against Invoke-DockerAlias's own parameter names by prefix
# (e.g. a tool's own "-w" or "-i" flag can be mistaken for -WorkingDir /
# -Image) when arguments are forwarded via `@args` directly. Rebuilding a
# fresh array with `+ [string[]]$args` before splatting avoids that ambiguity
# and forces purely positional binding, so every function below follows that
# pattern instead of `Invoke-DockerAlias ... @args`.

# A few of these tools (ripgrep, tmux, fd) have no official pre-built image,
# so this helper installs the requested apk package into an ephemeral
# alpine:latest container on every run, then execs the binary.
# Usage: New-AlpineCliAlias -Name <alias-name> -Package <apk-package> [-Binary <binary-name>]
function New-AlpineCliAlias {
    param(
        [Parameter(Mandatory)] [string] $Name,
        [Parameter(Mandatory)] [string] $Package,
        [Parameter()] [string] $Binary = $Package
    )

    # Single-quoted here-string: no PowerShell interpolation at all, so the
    # embedded "$@" survives untouched for the shell (`sh`) to expand at
    # runtime. {0}/{1}/{2} are filled in afterwards via -f; literal braces
    # for the function body are doubled to escape them from the formatter.
    $template = @'
function global:{0} {{
    $dockerAliasArgs = @('/app', 'alpine:latest', 'sh', '-c', 'apk add --no-cache --quiet "{1}" 1>&2 && exec {2} "$@"', '--') + [string[]]$args
    Invoke-DockerAlias @dockerAliasArgs
}}
'@
    Invoke-Expression ($template -f $Name, $Package, $Binary)
}

# yamllint — YAML linter — usage: yamllint-docker file.yml
function yamllint-docker {
    $a = @('/app', 'cytopia/yamllint:latest', 'yamllint') + [string[]]$args
    Invoke-DockerAlias @a
}

# ShellCheck — static analysis/linter for shell scripts (official image)
# usage: shellcheck-docker script.sh
function shellcheck-docker {
    $a = @('/mnt', 'koalaman/shellcheck:stable') + [string[]]$args
    Invoke-DockerAlias @a
}

# shfmt (bashfmt) — shell script formatter (official image)
# usage: shfmt-docker -l -w script.sh
function shfmt-docker {
    $a = @('/app', 'mvdan/shfmt:latest') + [string[]]$args
    Invoke-DockerAlias @a
}

# nmap — network discovery and security auditing — usage: nmap-docker -A -T4 scanme.nmap.org
function nmap-docker {
    $a = @('/app', 'instrumentisto/nmap:latest') + [string[]]$args
    Invoke-DockerAlias @a
}

# jq — command-line JSON processor (official image) — usage: jq-docker '.' file.json
function jq-docker {
    $a = @('/app', 'ghcr.io/jqlang/jq:latest') + [string[]]$args
    Invoke-DockerAlias @a
}

# ripgrep — fast recursive grep alternative — usage: rg-docker "TODO"
New-AlpineCliAlias -Name rg-docker -Package ripgrep -Binary rg

# tmux — terminal multiplexer — usage: tmux-docker new -s work
New-AlpineCliAlias -Name tmux-docker -Package tmux -Binary tmux

# fd — fast, user-friendly alternative to find — usage: fd-docker "\.log$"
New-AlpineCliAlias -Name fd-docker -Package fd -Binary fd

# rsync — fast incremental file transfer/sync — usage: rsync-docker -av src/ dest/
function rsync-docker {
    $a = @('/app', 'instrumentisto/rsync-ssh:latest', 'rsync') + [string[]]$args
    Invoke-DockerAlias @a
}

# rclone — sync/manage files across cloud storage providers (official image)
# usage: rclone-docker ls remote:bucket
function rclone-docker {
    $a = @('/app', 'rclone/rclone:latest') + [string[]]$args
    Invoke-DockerAlias @a
}

# watchdog — Python filesystem watcher, provides the `watchmedo` CLI to run
# shell commands on file changes. https://github.com/gorakhargosh/watchdog
# There is no official pre-built image, so it's pip-installed at runtime.
# usage: watchdog-docker shell-command --patterns="*.py" --command='pytest'
function watchdog-docker {
    $a = @('/app', 'python:3.13-slim', 'sh', '-c', 'pip install --quiet --no-cache-dir watchdog 1>&2 && exec watchmedo "$@"', '--') + [string[]]$args
    Invoke-DockerAlias @a
}

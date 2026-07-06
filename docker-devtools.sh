#!/bin/bash

function _docker_devtools_parse_bool() {
    local name value
    name=$1
    value=${2,,}

    case "$value" in
        1|true|yes|on) return 0 ;;
        ""|0|false|no|off) return 1 ;;
        *)
            echo "docker-devtools: invalid ${name} value '$2' (expected true or false)." >&2
            return 2
            ;;
    esac
}

function docker_alias() {
    local working_dir image tty_mode
    local -a docker_args extra_args

    if [ "$#" -lt 2 ]; then
        echo "docker-devtools: docker_alias requires a working directory and image." >&2
        return 2
    fi

    if ! command -v docker >/dev/null 2>&1; then
        echo "docker-devtools: docker is not installed or not in PATH." >&2
        return 127
    fi

    working_dir=$1
    image=$2
    shift 2

    tty_mode=${DOCKER_DEVTOOLS_TTY:-always}

    docker_args=(run)

    case "$tty_mode" in
        always)
            docker_args+=(-it)
            ;;
        auto)
            if [ -t 0 ] && [ -t 1 ]; then
                docker_args+=(-it)
            fi
            ;;
        never)
            ;;
        *)
            echo "docker-devtools: invalid DOCKER_DEVTOOLS_TTY value '$tty_mode' (expected always, auto, or never)." >&2
            return 2
            ;;
    esac

    docker_args+=(
        --rm
        -v "$PWD:$working_dir"
        -w "$working_dir"
    )

    if _docker_devtools_parse_bool DOCKER_DEVTOOLS_MAP_HOST_USER "${DOCKER_DEVTOOLS_MAP_HOST_USER:-}"; then
        docker_args+=(--user "$(id -u):$(id -g)")
    else
        case $? in
            1) ;;
            2) return 2 ;;
        esac
    fi

    if [ -n "${DOCKER_DEVTOOLS_EXTRA_ARGS:-}" ]; then
        read -r -a extra_args <<< "${DOCKER_DEVTOOLS_EXTRA_ARGS}"
        docker_args+=("${extra_args[@]}")
    fi

    docker_args+=(
        "$image"
        "$@"
    )

    docker "${docker_args[@]}"
}

function _docker_devtools_source() {
    local alias_file
    alias_file=$1

    if [ ! -f "$alias_file" ]; then
        echo "docker-devtools: missing required alias file: $alias_file" >&2
        return 1
    fi

    source "$alias_file"
}

_docker_devtools_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_docker_devtools_source "$_docker_devtools_dir/php/docker-php-devtools.sh"       || return 1 2>/dev/null || exit 1
_docker_devtools_source "$_docker_devtools_dir/js/docker-js-devtools.sh"         || return 1 2>/dev/null || exit 1
_docker_devtools_source "$_docker_devtools_dir/python/docker-python-devtools.sh" || return 1 2>/dev/null || exit 1

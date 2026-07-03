#!/bin/bash
function docker_alias() {
    local working_dir image
    local -a docker_args

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

    docker_args=(
        run -it --rm
        -v "$PWD:$working_dir"
        -w "$working_dir"
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

_docker_devtools_source "$_docker_devtools_dir/php/docker-php-devtools.sh" || return 1 2>/dev/null || exit 1
_docker_devtools_source "$_docker_devtools_dir/js/docker-js-devtools.sh"   || return 1 2>/dev/null || exit 1

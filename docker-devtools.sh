#!/bin/bash
function docker_alias() {
    docker run -it --rm \
        -v $(pwd):$1 -w $1 \
        ${@:2}
}

source ~/.docker-devtools/php/docker-php-devtools.sh
source ~/.docker-devtools/js/docker-js-devtools.sh

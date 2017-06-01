#!/bin/bash
function docker_alias() {
    docker run -it --rm \
        -v $(pwd):$1 -w $1 \
        ${@:2}
}

alias phpcs-cakephp="docker_alias /app willhallonline/cakephp-phpcs phps"
alias phpcbf-cakephp="docker_alias /app willhallonline/cakephp-phpcs phpcbf"
alias phpcs-wordpress="docker_alias /app willhallonline/wordpress-phpcs phpcs"
alias phpcbf-wordpress="docker_alias /app willhallonline/wordpress-phpcs phpcbf"
alias phpcs-drupal="docker_alias /app willhallonline/drupal-phpcs phpcs"
alias phpcbf-drupal="docker_alias /app willhallonline/drupal-phpcs phpcbf"
alias phpcs-yii="docker_alias /app willhallonline/yii-phpcs phpcs"
alias phpcbf-yii="docker_alias /app willhallonline/yii-phpcs phpcbf"
alias phpcs-laravel="docker_alias /app willhallonline/laravel-phpcs phpcs"
alias phpcbf-laravel="docker_alias /app willhallonline/laravel-phpcs phpcbf"
alias phpcs-docker="docker_alias /app willhallonline/phpcs:alpine phpcs"
alias phpcbf-docker="docker_alias /app willhallonline/phpcs:alpine phpcbf"
alias composer-docker="docker_alias /app willhallonline/composer:alpine composer"

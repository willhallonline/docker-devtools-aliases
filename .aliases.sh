#!/bin/bash
function docker_alias() {
    docker run -it --rm \
        -v $(pwd):$1 -w $1 \
        ${@:2}
}

alias phpcs-cakephp="docker_alias /directory willhallonline/cakephp-phpcs phps"
alias phpcbf-cakephp="docker_alias /directory willhallonline/cakephp-phpcs phpcbf"
alias phpcs-wordpress="docker_alias /directory willhallonline/wordpress-phpcs phpcs"
alias phpcbf-wordpress="docker_alias /directory willhallonline/wordpress-phpcs phpcbf"
alias phpcs-drupal="docker_alias /directory willhallonline/drupal-phpcs phpcs"
alias phpcbf-drupal="docker_alias /directory willhallonline/drupal-phpcs phpcbf"
alias phpcs-yii="docker_alias /directory willhallonline/yii-phpcs phpcs"
alias phpcbf-yii="docker_alias /directory willhallonline/yii-phpcs phpcbf"
alias phpcs-laravel="docker_alias /directory willhallonline/laravel-phpcs phpcs"
alias phpcbf-laravel="docker_alias /directory willhallonline/laravel-phpcs phpcbf"
alias phpcs-docker="docker_alias /directory willhallonline/phpcs:alpine phpcs"
alias phpcbf-docker="docker_alias /directory willhallonline/phpcs:alpine phpcbf"
alias composer-docker="docker_alias /directory willhallonline/composer:alpine composer"

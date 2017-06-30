#!/bin/bash
function docker_alias() {
    docker run -it --rm \
        -v $(pwd):$1 -w $1 \
        ${@:2}
}

alias phpcs-cakephp="docker_alias /app willhallonline/cakephp-phpcs:alpine phps"
alias phpcbf-cakephp="docker_alias /app willhallonline/cakephp-phpcs:alpine phpcbf"
alias phpcs-wordpress="docker_alias /app willhallonline/wordpress-phpcs:alpine phpcs"
alias phpcbf-wordpress="docker_alias /app willhallonline/wordpress-phpcs:alpine phpcbf"
alias phpcs-drupal="docker_alias /app willhallonline/drupal-phpcs:alpine phpcs --extensions=php,inc,install,module,theme"
alias phpcbf-drupal="docker_alias /app willhallonline/drupal-phpcs:alpine phpcbf --extensions=php,inc,install,module,theme"
alias phpcs-yii="docker_alias /app willhallonline/yii-phpcs:alpine phpcs"
alias phpcbf-yii="docker_alias /app willhallonline/yii-phpcs:alpine phpcbf"
alias phpcs-laravel="docker_alias /app willhallonline/laravel-phpcs:alpine phpcs"
alias phpcbf-laravel="docker_alias /app willhallonline/laravel-phpcs:alpine phpcbf"
alias phpcs-docker="docker_alias /app willhallonline/phpcs:alpine phpcs"
alias phpcbf-docker="docker_alias /app willhallonline/phpcs:alpine phpcbf"
alias composer-docker="docker_alias /app willhallonline/composer:alpine composer"

# Stylelint
alias stylelint-docker="docker_alias /app willhallonline/stylelint:alpine"

# ESLint
alias eslint-standard="docker_alias /app willhallonline/eslint-standard:alpine"
alias eslint-airbnb="docker_alias /app willhallonline/eslint-airbnb:alpine"

# JavaScript / CoffeeScript
alias node-docker="docker_alias ./ node:alpine node"
alias npm-docker="docker_alias ./ node:alpine npm"
alias coffee-docker="docker_alias ./ shouldbee/coffeescript coffee"

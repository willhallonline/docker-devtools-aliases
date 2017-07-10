# Composer
alias composer-docker="docker_alias /app willhallonline/composer:alpine composer"

# PHP Codesniffer
alias phpcs-d='~/.composer/vendor/bin/phpcs --standard=~/.composer/vendor/drupal/coder/coder_sniffer/Drupal --extensions=php,inc,install,module,theme'
alias phpcbf-d='~/.composer/vendor/bin/phpcbf --standard=~/.composer/vendor/drupal/coder/coder_sniffer/Drupal --extensions=php,inc,install,module,theme'
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

# Composer
alias composer-docker="docker_alias /app willhallonline/composer:alpine composer"

# PHP CodeSniffer — local binaries (Drupal Coder)
alias phpcs-d='~/.composer/vendor/bin/phpcs --standard=~/.composer/vendor/drupal/coder/coder_sniffer/Drupal --extensions=php,inc,install,module,theme'
alias phpcbf-d='~/.composer/vendor/bin/phpcbf --standard=~/.composer/vendor/drupal/coder/coder_sniffer/Drupal --extensions=php,inc,install,module,theme'

# PHP CodeSniffer — Docker images
# Registers a phpcs/phpcbf alias pair: _phpcs_pair <name> <image> [extra-args]
_phpcs_pair() {
    local name="$1" image="$2" extra="${3-}"
    alias "phpcs-${name}"="docker_alias /app ${image} phpcs${extra:+ ${extra}}"
    alias "phpcbf-${name}"="docker_alias /app ${image} phpcbf${extra:+ ${extra}}"
}

_phpcs_pair cakephp   willhallonline/cakephp-phpcs:alpine
_phpcs_pair wordpress willhallonline/wordpress-phpcs:alpine
_phpcs_pair drupal    willhallonline/drupal-phpcs:alpine    "--extensions=php,inc,install,module,theme"
_phpcs_pair yii       willhallonline/yii-phpcs:alpine
_phpcs_pair laravel   willhallonline/laravel-phpcs:alpine
_phpcs_pair docker    willhallonline/phpcs:alpine

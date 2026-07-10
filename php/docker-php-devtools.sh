# PHP Package Management
#
# Composer (official image, PHP 8.4-alpine LTS)
alias composer-docker="docker_alias /app composer:latest composer"
alias php-docker="docker_alias /app php:8.4-alpine php"

# Static analysis & code style
#
# PHPStan — static analysis (official image)
alias phpstan-docker="docker_alias /app phpstan/phpstan:latest"

# Psalm — static analysis (official image)
alias psalm-docker="docker_alias /app ghcr.io/vimeo/psalm:latest"

# PHP-CS-Fixer — code style fixer (community image)
alias php-cs-fixer-docker="docker_alias /app cytopia/php-cs-fixer:latest"

# PHP CodeSniffer
#
# Local binaries (Drupal Coder)
# Caveat: requires ~/.composer/vendor/bin/phpcs from local Composer install
alias phpcs-d='~/.composer/vendor/bin/phpcs --standard=~/.composer/vendor/drupal/coder/coder_sniffer/Drupal --extensions=php,inc,install,module,theme'
alias phpcbf-d='~/.composer/vendor/bin/phpcbf --standard=~/.composer/vendor/drupal/coder/coder_sniffer/Drupal --extensions=php,inc,install,module,theme'

# Docker images (community-maintained texthtml/phpcs with PHP CodeSniffer 4.0.1)
# Register phpcs/phpcbf alias pairs: _phpcs_pair <name> [extra-args]
_phpcs_pair() {
    local name="$1" extra="${2-}"
    alias "phpcs-${name}"="docker_alias /app texthtml/phpcs:latest phpcs${extra:+ ${extra}}"
    alias "phpcbf-${name}"="docker_alias /app texthtml/phpcs:latest phpcbf${extra:+ ${extra}}"
}

# Framework-specific PHPCS aliases (configure standards via .phpcs.xml in project root)
_phpcs_pair cakephp
_phpcs_pair wordpress
_phpcs_pair drupal    "--extensions=php,inc,install,module,theme"
_phpcs_pair yii
_phpcs_pair laravel
_phpcs_pair symfony
_phpcs_pair generic   # Generic PSR-12 / custom standards

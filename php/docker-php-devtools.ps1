# Docker DevTools — PHP (PowerShell)

# PHP Package Management
#
# Composer (official image, PHP 8.4-alpine LTS)
function composer-docker { Invoke-DockerAlias /app composer:latest composer @args }
function php-docker { Invoke-DockerAlias /app php:8.4-alpine php @args }

# PHP CodeSniffer — local binaries (Drupal Coder)
# Requires a local Composer-installed copy of drupal/coder (~/.composer/vendor/drupal/coder).
# These do NOT use Docker.
function phpcs-d {
    $phpcsBin = Join-Path $HOME '.composer/vendor/bin/phpcs'
    $standard = Join-Path $HOME '.composer/vendor/drupal/coder/coder_sniffer/Drupal'
    & $phpcsBin "--standard=$standard" '--extensions=php,inc,install,module,theme' @args
}

function phpcbf-d {
    $phpcbfBin = Join-Path $HOME '.composer/vendor/bin/phpcbf'
    $standard = Join-Path $HOME '.composer/vendor/drupal/coder/coder_sniffer/Drupal'
    & $phpcbfBin "--standard=$standard" '--extensions=php,inc,install,module,theme' @args
}

# Docker images (community-maintained texthtml/phpcs with PHP CodeSniffer 4.0.1)
# Registers a phpcs/phpcbf function pair: New-PhpcsPair <name> [extra-args...]
function New-PhpcsPair {
    param(
        [Parameter(Mandatory)] [string] $Name,
        [Parameter()] [string[]] $ExtraArgs = @()
    )

    Set-Item -Path "function:global:phpcs-$Name" -Value {
        Invoke-DockerAlias /app texthtml/phpcs:latest phpcs @ExtraArgs @args
    }.GetNewClosure()

    Set-Item -Path "function:global:phpcbf-$Name" -Value {
        Invoke-DockerAlias /app texthtml/phpcs:latest phpcbf @ExtraArgs @args
    }.GetNewClosure()
}

# Framework-specific PHPCS aliases (configure standards via .phpcs.xml in project root)
New-PhpcsPair -Name cakephp
New-PhpcsPair -Name wordpress
New-PhpcsPair -Name drupal    -ExtraArgs '--extensions=php,inc,install,module,theme'
New-PhpcsPair -Name yii
New-PhpcsPair -Name laravel
New-PhpcsPair -Name symfony
New-PhpcsPair -Name generic   # Generic PSR-12 / custom standards

# Docker DevTools — PHP (PowerShell)

# Composer
function composer-docker { Invoke-DockerAlias /app willhallonline/composer:alpine composer @args }

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

# PHP CodeSniffer — Docker images
# Registers a phpcs/phpcbf function pair: New-PhpcsPair <name> <image> [extra-args...]
function New-PhpcsPair {
    param(
        [Parameter(Mandatory)] [string] $Name,
        [Parameter(Mandatory)] [string] $Image,
        [Parameter()] [string[]] $ExtraArgs = @()
    )

    Set-Item -Path "function:global:phpcs-$Name" -Value {
        Invoke-DockerAlias /app $Image phpcs @ExtraArgs @args
    }.GetNewClosure()

    Set-Item -Path "function:global:phpcbf-$Name" -Value {
        Invoke-DockerAlias /app $Image phpcbf @ExtraArgs @args
    }.GetNewClosure()
}

New-PhpcsPair -Name cakephp   -Image willhallonline/cakephp-phpcs:alpine
New-PhpcsPair -Name wordpress -Image willhallonline/wordpress-phpcs:alpine
New-PhpcsPair -Name drupal    -Image willhallonline/drupal-phpcs:alpine -ExtraArgs '--extensions=php,inc,install,module,theme'
New-PhpcsPair -Name yii       -Image willhallonline/yii-phpcs:alpine
New-PhpcsPair -Name laravel   -Image willhallonline/laravel-phpcs:alpine
New-PhpcsPair -Name docker    -Image willhallonline/phpcs:alpine

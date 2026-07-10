# Docker DevTools — Ruby (PowerShell)
# Not sourced automatically; source explicitly if needed:
#   . "$HOME/.docker-devtools/ruby/docker-ruby-devtools.ps1"

# Ruby (official image) — usage: ruby-docker script.rb
function ruby-docker { Invoke-DockerAlias /app ruby:alpine ruby @args }
function ruby-bash-docker { Invoke-DockerAlias /app ruby:alpine /bin/sh @args }
function gem-docker { Invoke-DockerAlias /app ruby:alpine gem @args }
function bundle-docker { Invoke-DockerAlias /app ruby:alpine bundle @args }

# RuboCop — Ruby style linter/formatter (community image) — usage: rubocop-docker -A .
function rubocop-docker { Invoke-DockerAlias /app pipelinecomponents/rubocop:latest rubocop @args }

# Ruby DevTools
#
# Aliases for the Ruby toolchain, run inside Docker containers. This file is
# NOT sourced automatically — add it explicitly if you need it:
#
#   source ~/.docker-devtools/docker-devtools.sh
#   source ~/.docker-devtools/ruby/docker-ruby-devtools.sh

# Ruby (official image) — usage: ruby-docker script.rb
alias ruby-docker="docker_alias /app ruby:alpine ruby"
alias ruby-bash-docker="docker_alias /app ruby:alpine /bin/sh"
alias gem-docker="docker_alias /app ruby:alpine gem"
alias bundle-docker="docker_alias /app ruby:alpine bundle"

# RuboCop — Ruby style linter/formatter (community image) — usage: rubocop-docker -A .
alias rubocop-docker="docker_alias /app pipelinecomponents/rubocop:latest rubocop"

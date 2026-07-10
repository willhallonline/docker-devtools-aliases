# Docker DevTools — JavaScript & CSS (PowerShell)

# JavaScript & CSS Linting
#
# ESLint (via community image with Node 22 LTS)
function eslint-docker { Invoke-DockerAlias /app pipelinecomponents/eslint:latest lint @args }

# Stylelint (via community image with Node 22 LTS)
function stylelint-docker { Invoke-DockerAlias /app solutiondrive/stylelint:latest lint @args }

# Runtime aliases
#
# Node.js (pinned to 22-alpine LTS)
function node-docker { Invoke-DockerAlias /app node:22-alpine node @args }
function node-bash-docker { Invoke-DockerAlias /app node:22-alpine /bin/bash @args }
function npm-docker { Invoke-DockerAlias /app node:22-alpine npm @args }
function yarn-docker { Invoke-DockerAlias /app node:22-alpine yarn @args }
function pnpm-docker { Invoke-DockerAlias /app node:22-alpine pnpm @args }

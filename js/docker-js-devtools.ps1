# Docker DevTools — JavaScript & CSS (PowerShell)

# JavaScript & CSS Linting
#
# ESLint (via community image with Node 22 LTS)
function eslint-docker { Invoke-DockerAlias /app pipelinecomponents/eslint:latest lint @args }

# Stylelint (via community image with Node 22 LTS)
function stylelint-docker { Invoke-DockerAlias /app solutiondrive/stylelint:latest lint @args }

# Prettier (community image)
function prettier-docker { Invoke-DockerAlias /app tmknom/prettier:latest @args }

# Biome — combined fast linter + formatter (official image)
function biome-docker { Invoke-DockerAlias /app ghcr.io/biomejs/biome:latest @args }

# tsc — TypeScript compiler / type-checker (no fixed official image, run via npx on Node 22)
function tsc-docker { Invoke-DockerAlias /app node:22-alpine npx --yes typescript tsc @args }

# Runtime aliases
#
# Node.js (pinned to 22-alpine LTS)
function node-docker { Invoke-DockerAlias /app node:22-alpine node @args }
function node-bash-docker { Invoke-DockerAlias /app node:22-alpine /bin/bash @args }
function npm-docker { Invoke-DockerAlias /app node:22-alpine npm @args }
function yarn-docker { Invoke-DockerAlias /app node:22-alpine yarn @args }
function pnpm-docker { Invoke-DockerAlias /app node:22-alpine pnpm @args }

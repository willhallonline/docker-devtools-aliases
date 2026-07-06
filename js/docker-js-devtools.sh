# JavaScript & CSS Linting
#
# ESLint (via community image with Node 22 LTS)
alias eslint-docker="docker_alias /app pipelinecomponents/eslint:latest lint"

# Stylelint (via community image with Node 22 LTS)
alias stylelint-docker="docker_alias /app solutiondrive/stylelint:latest lint"

# Runtime aliases
#
# Node.js (pinned to 22-alpine LTS)
alias node-docker="docker_alias /app node:22-alpine node"
alias node-bash-docker="docker_alias /app node:22-alpine /bin/bash"
alias npm-docker="docker_alias /app node:22-alpine npm"
alias yarn-docker="docker_alias /app node:22-alpine yarn"
alias pnpm-docker="docker_alias /app node:22-alpine pnpm"

# Docker DevTools — JavaScript / CSS (PowerShell)

# Stylelint
function stylelint-docker { Invoke-DockerAlias /app willhallonline/stylelint:alpine @args }

# Prettier
function prettier-docker { Invoke-DockerAlias /app tmknom/prettier:latest @args }

# ESLint
function eslint-standard { Invoke-DockerAlias /app willhallonline/eslint-standard:alpine @args }
function eslint-airbnb { Invoke-DockerAlias /app willhallonline/eslint-airbnb:alpine @args }

# Node.js
function node-docker { Invoke-DockerAlias /app node:alpine node @args }
function npm-docker { Invoke-DockerAlias /app node:alpine npm @args }
function yarn-docker { Invoke-DockerAlias /app node:alpine yarn @args }
function node-bash-docker { Invoke-DockerAlias /app node /bin/bash @args }

# CoffeeScript
function coffee-docker { Invoke-DockerAlias /app shouldbee/coffeescript coffee @args }

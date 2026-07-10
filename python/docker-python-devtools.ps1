# Docker DevTools — Python (PowerShell)

# Python / pip
function python-docker { Invoke-DockerAlias /app python:alpine python @args }
function pip-docker { Invoke-DockerAlias /app python:alpine pip @args }
function python-bash-docker { Invoke-DockerAlias /app python:alpine /bin/sh @args }

# Black — code formatter
function black-docker { Invoke-DockerAlias /app pyfound/black:latest_release black @args }

# Flake8 — style guide enforcement (PEP 8)
function flake8-docker { Invoke-DockerAlias /app alpine/flake8:latest flake8 @args }

# Pylint — static code analysis / linter
function pylint-docker { Invoke-DockerAlias /app cytopia/pylint:latest pylint @args }

# Mypy — static type checker
function mypy-docker { Invoke-DockerAlias /app cytopia/mypy:latest mypy @args }

# Bandit — security linter
function bandit-docker { Invoke-DockerAlias /app cytopia/bandit:latest bandit @args }

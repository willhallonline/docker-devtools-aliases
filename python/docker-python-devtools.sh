# Python / pip
alias python-docker="docker_alias /app python:alpine python"
alias pip-docker="docker_alias /app python:alpine pip"
alias python-bash-docker="docker_alias /app python:alpine /bin/sh"

# Black — code formatter
alias black-docker="docker_alias /app pyfound/black:latest_release black"

# Flake8 — style guide enforcement (PEP 8)
alias flake8-docker="docker_alias /app alpine/flake8:latest flake8"

# Pylint — static code analysis / linter
alias pylint-docker="docker_alias /app cytopia/pylint:latest pylint"

# Mypy — static type checker
alias mypy-docker="docker_alias /app cytopia/mypy:latest mypy"

# Bandit — security linter
alias bandit-docker="docker_alias /app cytopia/bandit:latest bandit"

# Ruff — fast linter/formatter (official image)
alias ruff-docker="docker_alias /app ghcr.io/astral-sh/ruff:latest"

# Poetry — dependency & package manager (community image)
alias poetry-docker="docker_alias /app cytopia/poetry:latest poetry"

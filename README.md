# Docker DevTools

Docker DevTools provides a set of shell aliases that run common developer tools (linters, formatters, package managers) inside Docker containers — no local language runtimes required.

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| **Docker** | Must be installed and in `PATH`. [Get Docker](https://docs.docker.com/get-docker/) |
| **Bash 4+** or **zsh** | The wrapper uses bash arrays; macOS ships bash 3 — upgrade via Homebrew (`brew install bash`) or use zsh |
| **git** | Recommended for installation and updates |

## Installation

### Clone (recommended)

```bash
git clone https://github.com/willhallonline/docker-devtools-aliases.git ~/.docker-devtools
```

Cloning lets you pull future updates with a simple `git pull`.

### Source in your shell profile

Add the following line to your `~/.bashrc` or `~/.zshrc`:

```bash
source ~/.docker-devtools/docker-devtools.sh
```

Then reload your shell:

```bash
source ~/.bashrc   # or: source ~/.zshrc
```

## Available tools

### JavaScript / CSS

| Alias | Tool | Image |
|-------|------|-------|
| `stylelint-docker` | Stylelint CSS linter (community image) | `solutiondrive/stylelint:latest` |
| `eslint-docker` | ESLint (community image) | `pipelinecomponents/eslint:latest` |
| `node-docker` | Node.js REPL / scripts | `node:22-alpine` |
| `npm-docker` | npm | `node:22-alpine` |
| `yarn-docker` | Yarn | `node:22-alpine` |
| `pnpm-docker` | pnpm | `node:22-alpine` |
| `node-bash-docker` | Interactive bash in Node container | `node:22-alpine` |

### PHP

| Alias | Tool | Image |
|-------|------|-------|
| `composer-docker` | Composer package manager | `willhallonline/composer:alpine` |
| `phpcs-docker` / `phpcbf-docker` | PHP_CodeSniffer (generic) | `willhallonline/phpcs:alpine` |
| `phpcs-drupal` / `phpcbf-drupal` | PHP_CodeSniffer (Drupal standard) | `willhallonline/drupal-phpcs:alpine` |
| `phpcs-wordpress` / `phpcbf-wordpress` | PHP_CodeSniffer (WordPress standard) | `willhallonline/wordpress-phpcs:alpine` |
| `phpcs-cakephp` / `phpcbf-cakephp` | PHP_CodeSniffer (CakePHP standard) | `willhallonline/cakephp-phpcs:alpine` |
| `phpcs-yii` / `phpcbf-yii` | PHP_CodeSniffer (Yii standard) | `willhallonline/yii-phpcs:alpine` |
| `phpcs-laravel` / `phpcbf-laravel` | PHP_CodeSniffer (Laravel standard) | `willhallonline/laravel-phpcs:alpine` |

> **Note:** `phpcs-d` and `phpcbf-d` (Drupal, local) are thin wrappers around `~/.composer/vendor/bin/phpcs` and require a local Composer-installed copy of `drupal/coder`. They do **not** use Docker.

### Images

The `images/docker-image-devtools.sh` file contains image-optimisation aliases (e.g. `jpegtran-docker`). This file is **not** sourced automatically — add it explicitly if you need it:

```bash
source ~/.docker-devtools/docker-devtools.sh
source ~/.docker-devtools/images/docker-image-devtools.sh
```

## Usage examples

All aliases mount the **current working directory** into the container and run the tool there. Arguments after the alias are forwarded directly to the tool.

```bash
# Lint a CSS file
stylelint-docker bad.css

# Lint all JS files in the current directory
eslint-docker .

# Run Composer install
composer-docker install

# Check PHP code against Drupal standards
phpcs-drupal src/

# Fix automatically with PHP Code Beautifier
phpcbf-drupal src/

# Run a Node.js script
node-docker script.js

# Install npm dependencies
npm-docker install
```

## Runtime configuration

Three environment variables let you adjust container behaviour without modifying aliases.

### `DOCKER_DEVTOOLS_TTY`

Controls whether `-it` (interactive + TTY) is passed to `docker run`.

| Value | Behaviour |
|-------|-----------|
| `always` *(default)* | Always pass `-it` |
| `auto` | Pass `-it` only when stdin **and** stdout are connected to a terminal |
| `never` | Never pass `-it` (safe for scripts and CI) |

```bash
# Disable TTY for use in a CI pipeline or script
DOCKER_DEVTOOLS_TTY=never phpcs-docker src/
```

### `DOCKER_DEVTOOLS_MAP_HOST_USER`

When set to a truthy value (`true`, `1`, `yes`, `on`), adds `--user $(id -u):$(id -g)` so files written by the container are owned by the current host user instead of `root`.

```bash
DOCKER_DEVTOOLS_MAP_HOST_USER=true composer-docker install
```

Accepts: `true`, `1`, `yes`, `on` (enable) or `false`, `0`, `no`, `off`, empty (disable — default).

### `DOCKER_DEVTOOLS_EXTRA_ARGS`

A space-separated list of extra flags appended to `docker run` **before** the image name. Useful for network, registry, or pull-policy overrides.

```bash
# Force a fresh pull and use the host network
DOCKER_DEVTOOLS_EXTRA_ARGS="--pull always --network host" stylelint-docker .
```

You can export these variables in your shell profile to apply them globally:

```bash
export DOCKER_DEVTOOLS_TTY=auto
export DOCKER_DEVTOOLS_MAP_HOST_USER=true
```

## Updating

```bash
cd ~/.docker-devtools
git pull
```

## Testing

A shell-based test harness is included. It stubs out Docker and the alias sub-files so no containers are pulled.

```bash
bash tests/run_tests.sh
```

Requires bash 4+. All 36 assertions cover argument validation, TTY mode, host-user mapping, extra args, and error handling.

## Troubleshooting

**`docker-devtools: docker is not installed or not in PATH.`**
Docker is missing or the daemon is not running. Install Docker or ensure `docker` is on your `PATH`.

**Output files are owned by root**
Set `DOCKER_DEVTOOLS_MAP_HOST_USER=true` so the container runs as your UID/GID.

**`the input device is not a TTY` in a script or CI**
Set `DOCKER_DEVTOOLS_TTY=never` (or `auto`) to suppress the `-it` flag.

**`invalid DOCKER_DEVTOOLS_TTY value`**
The variable must be exactly `always`, `auto`, or `never`.

**`invalid DOCKER_DEVTOOLS_MAP_HOST_USER value`**
The variable must be a recognised boolean: `true`/`false`, `1`/`0`, `yes`/`no`, or `on`/`off`.

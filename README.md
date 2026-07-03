# Docker DevTools

Shell aliases that run developer tools (linters, formatters, compilers) inside Docker containers — no local installs required beyond Docker itself.

## Prerequisites

- **Docker** — must be installed and in `PATH`. [Get Docker](https://docs.docker.com/get-docker/).
- **Bash 4+** or **zsh** — macOS ships with Bash 3; install a newer version via `brew install bash` or use zsh.
- **Git** — recommended for installation and updates.

## Installation

Clone the repository to any location on your machine:

```bash
git clone https://github.com/willhallonline/docker-devtools-aliases.git ~/.docker-devtools
```

Then add the following line to your `~/.bashrc` or `~/.zshrc`:

```bash
source ~/.docker-devtools/docker-devtools.sh
```

Reload your shell or run `source ~/.bashrc` (or `~/.zshrc`) to activate the aliases.

> **Note:** The clone path is flexible — the script resolves alias sub-files relative to its own location, so `~/.docker-devtools` is a convention, not a requirement.

### Optional: image optimisation aliases

The `images/` pack (currently `jpegtran-docker`) is **not sourced automatically**. To enable it, add an extra line after the main source:

```bash
source ~/.docker-devtools/docker-devtools.sh
source ~/.docker-devtools/images/docker-image-devtools.sh
```

## Available Aliases

### PHP (`php/docker-php-devtools.sh`)

| Alias | Description |
|-------|-------------|
| `composer-docker` | [Composer](https://getcomposer.org/) package manager |
| `phpcs-docker` | PHP CodeSniffer (generic) |
| `phpcbf-docker` | PHP Code Beautifier and Fixer (generic) |
| `phpcs-cakephp` / `phpcbf-cakephp` | CodeSniffer with CakePHP standard |
| `phpcs-wordpress` / `phpcbf-wordpress` | CodeSniffer with WordPress standard |
| `phpcs-drupal` / `phpcbf-drupal` | CodeSniffer with Drupal standard |
| `phpcs-yii` / `phpcbf-yii` | CodeSniffer with Yii standard |
| `phpcs-laravel` / `phpcbf-laravel` | CodeSniffer with Laravel standard |
| `phpcs-d` / `phpcbf-d` | Drupal Coder via **local** `~/.composer/vendor/bin/phpcs` (see [Caveats](#caveats)) |

### JavaScript / CSS (`js/docker-js-devtools.sh`)

| Alias | Description |
|-------|-------------|
| `stylelint-docker` | [Stylelint](https://stylelint.io/) CSS/SCSS linter |
| `eslint-standard` | [ESLint](https://eslint.org/) with Standard config |
| `eslint-airbnb` | ESLint with Airbnb config |
| `node-docker` | Node.js REPL / script runner |
| `npm-docker` | npm package manager |
| `yarn-docker` | Yarn package manager |
| `node-bash-docker` | Interactive bash shell in a Node.js container |
| `coffee-docker` | [CoffeeScript](https://coffeescript.org/) compiler |

### Image Optimisation (`images/docker-image-devtools.sh` — opt-in)

| Alias | Description |
|-------|-------------|
| `jpegtran-docker` | Lossless JPEG optimisation via [mozjpeg](https://github.com/mozilla/mozjpeg) |

## Usage

Each alias mounts your **current working directory** into the container at the tool's expected working path, runs the tool with any arguments you pass, and then removes the container.

**Example — lint a CSS file with Stylelint:**

```bash
cd /path/to/your/project
stylelint-docker bad.css
```

```
bad.css
 1:6   ✖  Expected single space after "{"  block-opening-brace-space-after
          of a single-line block
 1:12  ✖  Expected single space after ":"  declaration-colon-space-after
          with a single-line declaration
 1:16  ✖  Expected single space before     block-closing-brace-space-before
          "}" of a single-line block
 1:16  ✖  Expected a trailing semicolon    declaration-block-trailing-semicolon
```

**Example — run Composer:**

```bash
cd /path/to/php/project
composer-docker install
```

## Runtime Configuration

> **Note:** This section will be completed once the runtime-configuration PR lands. It will document environment variables that can override default image tags, registry, and container behaviour.

## Testing

The test harness exercises `docker-devtools.sh` without spawning real containers:

```bash
bash tests/run_tests.sh
```

- Requires Bash 4+
- No Docker daemon needed — Docker is stubbed internally
- Covers: argument validation, volume-mount construction, space-safe paths, argument passthrough, alias-file loading, missing-file errors, and missing-docker detection

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `docker-devtools: docker is not installed or not in PATH` | Docker missing or not on `PATH` | Install Docker or fix your `PATH` |
| `docker-devtools: missing required alias file` | Partial clone or corrupted install | Re-clone the repository |
| Aliases not found after shell restart | Source line missing from RC file | Add `source <install-dir>/docker-devtools.sh` to `~/.bashrc` or `~/.zshrc` |
| `jpegtran-docker: command not found` | `images/` pack not sourced | Add the opt-in source line (see [Installation](#installation)) |
| `phpcs-d` / `phpcbf-d` not working | Local Drupal Coder not installed | Run `composer global require drupal/coder` |

## Updating

```bash
cd ~/.docker-devtools
git pull
```

Reload your shell after updating.

## Caveats

- **`images/docker-image-devtools.sh` is not auto-sourced.** This is intentional — it keeps the default `source` line minimal. Opt in by sourcing the file explicitly (see [Installation](#installation)).
- **`phpcs-d` / `phpcbf-d` call local binaries, not Docker.** These two aliases invoke `~/.composer/vendor/bin/phpcs` and `~/.composer/vendor/bin/phpcbf` directly on your machine, relying on a global Composer install of `drupal/coder`. This is by design.
- **`node-bash-docker` uses the untagged `node` image.** All other Node.js aliases use `node:alpine`; `node-bash-docker` uses `node` (latest). This is existing behaviour left intentionally unchanged.

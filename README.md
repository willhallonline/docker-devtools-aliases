# Docker DevTools

Docker DevTools provides a set of shell aliases that run common developer tools (linters, formatters, package managers) inside Docker containers — no local language runtimes required.

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| **Docker** | Must be installed and in `PATH`. [Get Docker](https://docs.docker.com/get-docker/) |
| **Bash 4+** or **zsh** | The wrapper uses bash arrays; macOS ships bash 3 — upgrade via Homebrew (`brew install bash`) or use zsh |
| **PowerShell 5.1+** or **PowerShell 7+** | Only needed if you use the `.ps1` scripts instead of the bash version (Windows, or cross-platform `pwsh`) |
| **git** | Recommended for installation and updates |

## Installation

### Clone (recommended)

```bash
git clone https://github.com/willhallonline/docker-devtools-aliases.git ~/.docker-devtools
```

Cloning lets you pull future updates with a simple `git pull`.

### Bash / zsh

Add the following line to your `~/.bashrc` or `~/.zshrc`:

```bash
source ~/.docker-devtools/docker-devtools.sh
```

Then reload your shell:

```bash
source ~/.bashrc   # or: source ~/.zshrc
```

### PowerShell

Clone to a location of your choice (e.g. `~/.docker-devtools` also works on Windows/PowerShell), then add the following line to your PowerShell profile (`$PROFILE`):

```powershell
. "$HOME/.docker-devtools/docker-devtools.ps1"
```

Reload your profile, or open a new session:

```powershell
. $PROFILE
```

The PowerShell scripts (`docker-devtools.ps1`, `js/docker-js-devtools.ps1`, `php/docker-php-devtools.ps1`, `python/docker-python-devtools.ps1`, `images/docker-image-devtools.ps1`, `ai/docker-ai-devtools.ps1`) mirror the bash versions tool-for-tool and work on Windows PowerShell 5.1+ and cross-platform PowerShell 7+ (`pwsh` on Linux/macOS). Bash `alias`es become PowerShell functions of the same name (e.g. `node-docker`, `phpcs-drupal`), since PowerShell aliases can't carry baked-in arguments. Every tool documented below — including image tools and AI tools — is available in both bash and PowerShell.

## Available tools

### JavaScript / CSS

| Alias | Tool | Image |
|-------|------|-------|
| `stylelint-docker` | Stylelint CSS linter (community image) | `solutiondrive/stylelint:latest` |
| `eslint-docker` | ESLint (community image) | `pipelinecomponents/eslint:latest` |
| `prettier-docker` | Prettier code formatter (community image) | `tmknom/prettier:latest` |
| `node-docker` | Node.js REPL / scripts | `node:22-alpine` |
| `npm-docker` | npm | `node:22-alpine` |
| `yarn-docker` | Yarn | `node:22-alpine` |
| `pnpm-docker` | pnpm | `node:22-alpine` |
| `node-bash-docker` | Interactive bash in Node container | `node:22-alpine` |

### PHP

| Alias | Tool | Image |
|-------|------|-------|
| `composer-docker` | Composer package manager (official image) | `composer:latest` |
| `php-docker` | PHP CLI / scripts | `php:8.4-alpine` |
| `phpcs-generic` / `phpcbf-generic` | PHP_CodeSniffer (generic, community image) | `texthtml/phpcs:latest` |
| `phpcs-drupal` / `phpcbf-drupal` | PHP_CodeSniffer (Drupal standard) | `texthtml/phpcs:latest` |
| `phpcs-wordpress` / `phpcbf-wordpress` | PHP_CodeSniffer (WordPress standard) | `texthtml/phpcs:latest` |
| `phpcs-cakephp` / `phpcbf-cakephp` | PHP_CodeSniffer (CakePHP standard) | `texthtml/phpcs:latest` |
| `phpcs-yii` / `phpcbf-yii` | PHP_CodeSniffer (Yii standard) | `texthtml/phpcs:latest` |
| `phpcs-laravel` / `phpcbf-laravel` | PHP_CodeSniffer (Laravel standard) | `texthtml/phpcs:latest` |
| `phpcs-symfony` / `phpcbf-symfony` | PHP_CodeSniffer (Symfony standard) | `texthtml/phpcs:latest` |

> **Note:** `phpcs-d` and `phpcbf-d` (Drupal, local) are thin wrappers around `~/.composer/vendor/bin/phpcs` and require a local Composer-installed copy of `drupal/coder`. They do **not** use Docker.
>
> All `phpcs-*` / `phpcbf-*` Docker aliases share a single community-maintained image (`texthtml/phpcs`, actively updated with PHP_CodeSniffer 4.0.1). Configure framework-specific standards via a `.phpcs.xml` in your project root, or pass `--standard=...` directly.

### Python

| Alias | Tool | Image |
|-------|------|-------|
| `python-docker` | Python REPL / scripts | `python:alpine` |
| `pip-docker` | pip package manager | `python:alpine` |
| `python-bash-docker` | Interactive shell in Python container | `python:alpine` |
| `black-docker` | Black code formatter | `pyfound/black:latest_release` |
| `flake8-docker` | Flake8 style/lint checker (PEP 8) | `alpine/flake8:latest` |
| `pylint-docker` | Pylint static analysis | `cytopia/pylint:latest` |
| `mypy-docker` | Mypy static type checker | `cytopia/mypy:latest` |
| `bandit-docker` | Bandit security linter | `cytopia/bandit:latest` |


### Images

The `images/docker-image-devtools.sh` file contains image-conversion, resizing, and optimisation aliases. This file is **not** sourced automatically — add it explicitly if you need it:

```bash
source ~/.docker-devtools/docker-devtools.sh
source ~/.docker-devtools/images/docker-image-devtools.sh
```

In PowerShell:

```powershell
. "$HOME/.docker-devtools/docker-devtools.ps1"
. "$HOME/.docker-devtools/images/docker-image-devtools.ps1"
```

| Alias | Tool | Image |
|-------|------|-------|
| `jpegtran-docker` | JPEG lossless transformation (mozjpeg) | `datawraith/mozjpeg` |
| `magick-docker` / `convert-docker` | ImageMagick — conversion & resizing | `dpokidov/imagemagick:latest` |
| `mogrify-docker` | ImageMagick — in-place batch conversion/resize | `dpokidov/imagemagick:latest` |
| `identify-docker` | ImageMagick — image metadata/info | `dpokidov/imagemagick:latest` |
| `vipsthumbnail-docker` | libvips — fast, low-memory thumbnailing/resizing | `marcbachmann/libvips:latest` |
| `cwebp-docker` / `dwebp-docker` | WebP encode/decode | `takecy/webp:latest` |

```bash
# Resize an image with ImageMagick
magick-docker input.jpg -resize 50% output.jpg

# Batch-resize and reformat in place
mogrify-docker -resize 800x600 -format png *.jpg

# Generate a fast thumbnail with libvips
vipsthumbnail-docker input.jpg --size 200x200 -o thumb.jpg

# Convert to/from WebP
cwebp-docker input.png -o output.webp
dwebp-docker output.webp -o roundtrip.png
```

### AI tools

The `ai/docker-ai-devtools.sh` file contains aliases for AI-powered CLI tools. This file is **not** sourced automatically — add it explicitly if you need it:

```bash
source ~/.docker-devtools/docker-devtools.sh
source ~/.docker-devtools/ai/docker-ai-devtools.sh
```

In PowerShell:

```powershell
. "$HOME/.docker-devtools/docker-devtools.ps1"
. "$HOME/.docker-devtools/ai/docker-ai-devtools.ps1"
```

| Alias | Tool | Image |
|-------|------|-------|
| `markitdown-docker` | [MarkItDown](https://github.com/microsoft/markitdown) — converts PDFs, Office docs, images, audio, HTML, etc. to Markdown for LLMs | `python:3.13-slim` (installs `markitdown` at runtime) |
| `llm-docker` | [llm](https://llm.datasette.io) — Simon Willison's CLI for prompting/piping data through LLMs | `python:3.13-slim` (installs `llm` at runtime) |
| `openwiki-docker` | [OpenWiki](https://github.com/langchain-ai/openwiki) — generates and maintains agent-readable docs for a codebase | `node:22-alpine` (via `npx`) |
| `aider-docker` | [Aider](https://aider.chat) — AI pair-programming CLI that edits files and commits changes in your repo | `paulgauthier/aider-full` |

> **Note:** `markitdown-docker` and `llm-docker` have no official pre-built image, so they `pip install` the package into a fresh `python:3.13-slim` container on every run (a few extra seconds per invocation). Most of these tools call an LLM provider and need an API key — pass it through with `DOCKER_DEVTOOLS_EXTRA_ARGS`, e.g. `DOCKER_DEVTOOLS_EXTRA_ARGS="-e OPENAI_API_KEY" aider-docker`.

```bash
# Convert a PDF to Markdown
markitdown-docker report.pdf > report.md

# Ask an LLM about piped input
cat notes.txt | llm-docker "Summarize this"

# Generate docs for the current repo
openwiki-docker --init

# Let Aider edit a file with AI assistance
DOCKER_DEVTOOLS_EXTRA_ARGS="-e OPENAI_API_KEY" aider-docker some_file.py
```

### Internet tools

The `internet/docker-internet-devtools.sh` file contains aliases for infrastructure-as-code CLIs, cloud CLIs, and Kubernetes tools. This file is **not** sourced automatically — add it explicitly if you need it:

```bash
source ~/.docker-devtools/docker-devtools.sh
source ~/.docker-devtools/internet/docker-internet-devtools.sh
```

In PowerShell:

```powershell
. "$HOME/.docker-devtools/docker-devtools.ps1"
. "$HOME/.docker-devtools/internet/docker-internet-devtools.ps1"
```

| Alias | Tool | Image |
|-------|------|-------|
| `terraform-docker` | Terraform (official image) | `hashicorp/terraform:latest` |
| `ansible-docker` / `ansible-playbook-docker` | Ansible / ansible-playbook | `willhallonline/ansible:latest` |
| `pulumi-docker` | Pulumi (official image) | `pulumi/pulumi:latest` |
| `az-docker` | Azure CLI (official image) | `mcr.microsoft.com/azure-cli:latest` |
| `aws-docker` | AWS CLI (official image) | `amazon/aws-cli:latest` |
| `gcloud-docker` | Google Cloud CLI (official image) | `google/cloud-sdk:latest` |
| `kubectl-docker` | kubectl (Bitnami image) | `bitnami/kubectl:latest` |
| `k9s-docker` | k9s (derailed/k9s image) | `derailed/k9s:latest` |
| `kubeadm-docker` | kubeadm (kind's node image; no standalone official kubeadm image exists) | `kindest/node:latest` |

```bash
# Run a Terraform plan
terraform-docker plan

# Run an Ansible playbook
ansible-playbook-docker site.yml

# List pods with kubectl
kubectl-docker get pods

# Browse the cluster with k9s
k9s-docker

# Check the kubeadm version
kubeadm-docker version
```

### Linux tools

The `linux/docker-linux-devtools.sh` file contains aliases for common Linux command-line utilities. This file is **not** sourced automatically — add it explicitly if you need it:

```bash
source ~/.docker-devtools/docker-devtools.sh
source ~/.docker-devtools/linux/docker-linux-devtools.sh
```

In PowerShell:

```powershell
. "$HOME/.docker-devtools/docker-devtools.ps1"
. "$HOME/.docker-devtools/linux/docker-linux-devtools.ps1"
```

| Alias | Tool | Image |
|-------|------|-------|
| `yamllint-docker` | yamllint — YAML linter | `cytopia/yamllint:latest` |
| `shellcheck-docker` | ShellCheck — shell script linter (official image) | `koalaman/shellcheck:stable` |
| `shfmt-docker` | shfmt (bashfmt) — shell script formatter (official image) | `mvdan/shfmt:latest` |
| `nmap-docker` | Nmap — network discovery and security auditing | `instrumentisto/nmap:latest` |
| `jq-docker` | jq — command-line JSON processor (official image) | `ghcr.io/jqlang/jq:latest` |
| `rg-docker` | ripgrep — fast recursive grep alternative | `alpine:latest` (installs `ripgrep` at runtime) |
| `tmux-docker` | tmux — terminal multiplexer | `alpine:latest` (installs `tmux` at runtime) |
| `fd-docker` | fd — fast, user-friendly alternative to `find` | `alpine:latest` (installs `fd` at runtime) |
| `rsync-docker` | rsync — fast incremental file transfer/sync | `instrumentisto/rsync-ssh:latest` |
| `rclone-docker` | rclone — sync/manage files across cloud storage providers (official image) | `rclone/rclone:latest` |
| `watchdog-docker` | watchdog's `watchmedo` — run commands on filesystem changes | `python:3.13-slim` (installs `watchdog` at runtime) |

> **Note:** `rg-docker`, `tmux-docker`, `fd-docker`, and `watchdog-docker` have no official pre-built image, so they install the package into a fresh container on every run (a few extra seconds per invocation).

```bash
# Lint a YAML file
yamllint-docker config.yml

# Lint and format a shell script
shellcheck-docker script.sh
shfmt-docker -l -w script.sh

# Scan a host
nmap-docker -A -T4 scanme.nmap.org

# Query JSON
jq-docker '.' data.json

# Search recursively for a pattern
rg-docker "TODO"

# Sync files
rsync-docker -av src/ dest/
rclone-docker ls remote:bucket
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
DOCKER_DEVTOOLS_TTY=never phpcs-generic src/
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

### `--entrypoint <name>` (alias definitions)

Some multi-tool images (e.g. ImageMagick, libvips, WebP) bake in a default entrypoint that doesn't match every binary the image ships. Alias authors can override it by passing `--entrypoint <name>` immediately after the image in a `docker_alias` call:

```bash
alias mogrify-docker="docker_alias /imgs dpokidov/imagemagick:latest --entrypoint mogrify"
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

Requires bash 4+. All 42 assertions cover argument validation, TTY mode, host-user mapping, extra args, entrypoint overrides, and error handling.

A matching PowerShell test harness (`tests/run_tests.ps1`) covers the same scenarios for the `.ps1` scripts, including `--entrypoint` overrides and short-flag passthrough (e.g. `-o`):

```powershell
pwsh tests/run_tests.ps1
```

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

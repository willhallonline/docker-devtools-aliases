# AI DevTools
#
# Aliases for AI-powered CLI tools, run inside Docker containers.
# This file is NOT sourced automatically by docker-devtools.sh — add it
# explicitly if you need it:
#
#   source ~/.docker-devtools/docker-devtools.sh
#   source ~/.docker-devtools/ai/docker-ai-devtools.sh
#
# Most of these tools call out to a remote LLM provider (OpenAI, Anthropic,
# OpenRouter, etc.) and need an API key. Pass provider credentials through
# with DOCKER_DEVTOOLS_EXTRA_ARGS, e.g.:
#
#   DOCKER_DEVTOOLS_EXTRA_ARGS="-e OPENAI_API_KEY" aider-docker
#
# Registers a pip-installed Python CLI alias that installs the package into
# an ephemeral python:3.13-slim container on every run, then execs the
# binary. There is no official pre-built image for these tools, so the
# trade-off is a few extra seconds of `pip install` per invocation in
# exchange for not needing a local Python runtime or a custom image build.
# Usage: _pip_cli_alias <alias-name> <pip-package> [binary-name]
_pip_cli_alias() {
    local name="$1" package="$2" binary="${3:-$2}"
    # shellcheck disable=SC2016
    alias "${name}"="docker_alias /app python:3.13-slim sh -c 'pip install --quiet --no-cache-dir \"${package}\" 1>&2 && exec ${binary} \"\$@\"' --"
}

# MarkItDown — converts PDFs, Office docs, images, audio, HTML, etc. to
# Markdown for use with LLMs. https://github.com/microsoft/markitdown
# Usage: markitdown-docker path-to-file.pdf > document.md
_pip_cli_alias markitdown-docker "markitdown[all]" markitdown

# llm — Simon Willison's CLI for prompting and piping data through LLMs,
# with a plugin ecosystem for most providers. https://llm.datasette.io
# Usage: llm-docker "Summarize this file" < notes.txt
_pip_cli_alias llm-docker llm llm

# OpenWiki — CLI that generates and maintains agent-readable documentation
# for a codebase (writes to ./openwiki/, updates AGENTS.md/CLAUDE.md).
# https://github.com/langchain-ai/openwiki
# Usage: openwiki-docker --init
alias openwiki-docker="docker_alias /app node:22-alpine npx --yes openwiki"

# Aider — AI pair-programming CLI that edits files in your local git repo
# and commits the changes. https://aider.chat
# Usage: aider-docker --openai-api-key "$OPENAI_API_KEY" some_file.py
alias aider-docker="docker_alias /app paulgauthier/aider-full"

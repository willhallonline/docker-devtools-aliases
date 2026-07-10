# Docker DevTools — AI tools (PowerShell)
#
# Functions for AI-powered CLI tools, run inside Docker containers.
# This file is NOT sourced automatically by docker-devtools.ps1 — add it
# explicitly if you need it:
#
#   . "$HOME/.docker-devtools/docker-devtools.ps1"
#   . "$HOME/.docker-devtools/ai/docker-ai-devtools.ps1"
#
# Most of these tools call out to a remote LLM provider (OpenAI, Anthropic,
# OpenRouter, etc.) and need an API key. Pass provider credentials through
# with DOCKER_DEVTOOLS_EXTRA_ARGS, e.g.:
#
#   $env:DOCKER_DEVTOOLS_EXTRA_ARGS = "-e OPENAI_API_KEY"; aider-docker

# Registers a pip-installed Python CLI function that installs the package
# into an ephemeral python:3.13-slim container on every run, then execs the
# binary. There is no official pre-built image for these tools, so the
# trade-off is a few extra seconds of `pip install` per invocation in
# exchange for not needing a local Python runtime or a custom image build.
# Usage: New-PipCliAlias <alias-name> <pip-package> [binary-name]
function New-PipCliAlias {
    param(
        [Parameter(Mandatory)] [string] $Name,
        [Parameter(Mandatory)] [string] $Package,
        [Parameter()] [string] $Binary = $Package
    )

    Set-Item -Path "function:global:$Name" -Value {
        $shCmd = "pip install --quiet --no-cache-dir `"$Package`" 1>&2 && exec $Binary `"`$@`""
        Invoke-DockerAlias /app python:3.13-slim sh -c $shCmd -- @args
    }.GetNewClosure()
}

# MarkItDown — converts PDFs, Office docs, images, audio, HTML, etc. to
# Markdown for use with LLMs. https://github.com/microsoft/markitdown
# Usage: markitdown-docker path-to-file.pdf > document.md
New-PipCliAlias -Name markitdown-docker -Package "markitdown[all]" -Binary markitdown

# llm — Simon Willison's CLI for prompting and piping data through LLMs,
# with a plugin ecosystem for most providers. https://llm.datasette.io
# Usage: llm-docker "Summarize this file" < notes.txt
New-PipCliAlias -Name llm-docker -Package llm -Binary llm

# OpenWiki — CLI that generates and maintains agent-readable documentation
# for a codebase (writes to ./openwiki/, updates AGENTS.md/CLAUDE.md).
# https://github.com/langchain-ai/openwiki
# Usage: openwiki-docker --init
function openwiki-docker { Invoke-DockerAlias /app node:22-alpine npx --yes openwiki @args }

# Aider — AI pair-programming CLI that edits files in your local git repo
# and commits the changes. https://aider.chat
# Usage: aider-docker --openai-api-key "$env:OPENAI_API_KEY" some_file.py
function aider-docker { Invoke-DockerAlias /app paulgauthier/aider-full @args }

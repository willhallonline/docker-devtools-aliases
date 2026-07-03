#!/usr/bin/env bash
# Minimal test harness for docker-devtools.sh
# Usage: bash tests/run_tests.sh
# Requires: bash 4+
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0
FAIL=0

# ── helpers ──────────────────────────────────────────────────────────────────

_pass() { printf '  \033[32mPASS\033[0m  %s\n' "$1"; PASS=$(( PASS + 1 )); }
_fail() { printf '  \033[31mFAIL\033[0m  %s\n  → %s\n' "$1" "$2"; FAIL=$(( FAIL + 1 )); }

assert_eq() {
    local desc="$1" expected="$2" actual="$3"
    if [[ "$actual" == "$expected" ]]; then
        _pass "$desc"
    else
        _fail "$desc" "expected $(printf '%q' "$expected"), got $(printf '%q' "$actual")"
    fi
}

assert_contains() {
    local desc="$1" needle="$2" haystack="$3"
    if [[ "$haystack" == *"$needle"* ]]; then
        _pass "$desc"
    else
        _fail "$desc" "expected to contain '$needle' in: $haystack"
    fi
}

assert_exit() {
    local desc="$1" expected_code="$2" actual_code="$3"
    if [[ "$actual_code" == "$expected_code" ]]; then
        _pass "$desc"
    else
        _fail "$desc" "expected exit $expected_code, got $actual_code"
    fi
}

# ── docker stub ──────────────────────────────────────────────────────────────
# Intercepts docker calls; writes argv JSON-ish string to a temp file so
# tests can assert on it without spawning real containers.

STUB_LOG="$(mktemp)"
trap 'rm -f "$STUB_LOG"' EXIT

docker() {
    printf '%s\n' "$@" > "$STUB_LOG"
}
export -f docker

_read_stub() { cat "$STUB_LOG"; }

# ── load the code under test ──────────────────────────────────────────────────
# Source only docker-devtools.sh; supply lightweight stubs for the alias
# sub-files so the harness doesn't depend on their exact contents.

_stub_alias_file() {
    local path="$1"
    mkdir -p "$(dirname "$path")"
    : > "$path"
}

_TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$_TMP_DIR" "$STUB_LOG"' EXIT

# Build a minimal replica of the repo layout under _TMP_DIR so we can
# source docker-devtools.sh in isolation.
cp "$REPO_ROOT/docker-devtools.sh" "$_TMP_DIR/"
_stub_alias_file "$_TMP_DIR/php/docker-php-devtools.sh"
_stub_alias_file "$_TMP_DIR/js/docker-js-devtools.sh"

# shellcheck source=/dev/null
source "$_TMP_DIR/docker-devtools.sh"

# ── tests ─────────────────────────────────────────────────────────────────────

echo ""
echo "docker_alias: argument validation"

# 1. Requires at least 2 args
output=$(docker_alias 2>&1) || true
assert_contains "too-few-args: stderr message" "requires a working directory" "$output"

rc=0; docker_alias 2>/dev/null || rc=$?
assert_exit "too-few-args: exit code 2" 2 "$rc"

# 2. Basic argv construction (working_dir, image, passthrough cmd)
(cd /tmp && docker_alias /app myimage:tag mycommand --flag value)
argv=$(_read_stub)
assert_contains "basic: run sub-command" "run" "$argv"
assert_contains "basic: --rm flag" "--rm" "$argv"
assert_contains "basic: volume mount contains working_dir" "/app" "$argv"
assert_contains "basic: image present" "myimage:tag" "$argv"
assert_contains "basic: passthrough cmd" "mycommand" "$argv"
assert_contains "basic: passthrough flag" "--flag" "$argv"
assert_contains "basic: passthrough value" "value" "$argv"

# 3. Working directory is passed as -w argument
echo ""
echo "docker_alias: -w working directory"
(cd /tmp && docker_alias /work/dir myimage:tag)
argv=$(_read_stub)
assert_contains "workdir: -w present" "-w" "$argv"
assert_contains "workdir: correct path" "/work/dir" "$argv"

# 4. PWD is quoted correctly (path with spaces)
echo ""
echo "docker_alias: spaces in PWD"
SPACE_DIR="$_TMP_DIR/path with spaces"
mkdir -p "$SPACE_DIR"
(cd "$SPACE_DIR" && docker_alias /app myimage:tag)
argv=$(_read_stub)
assert_contains "spaces-in-pwd: volume mount contains spaced path" "path with spaces" "$argv"

# 5. Multiple passthrough arguments preserved
echo ""
echo "docker_alias: argument passthrough"
(cd /tmp && docker_alias /app myimage arg1 "arg with spaces" arg3)
argv=$(_read_stub)
assert_contains "passthrough: arg1" "arg1" "$argv"
assert_contains "passthrough: arg with spaces" "arg with spaces" "$argv"
assert_contains "passthrough: arg3" "arg3" "$argv"

# 6. Representative alias: composer-docker (if defined in php stub, skip gracefully)
echo ""
echo "alias loading: sub-files sourced without error"
# Both alias files were sourced; no fatal error means loading passed.
# We verify docker_alias itself is still callable.
rc=0; type docker_alias >/dev/null 2>&1 || rc=$?
assert_exit "alias-load: docker_alias still defined after source" 0 "$rc"

# 7. Missing alias file returns non-zero (test _docker_devtools_source directly)
echo ""
echo "_docker_devtools_source: missing file"
output=$(_docker_devtools_source "/nonexistent/file.sh" 2>&1) || true
assert_contains "missing-file: stderr message" "missing required alias file" "$output"

rc=0; _docker_devtools_source "/nonexistent/file.sh" 2>/dev/null || rc=$?
assert_exit "missing-file: exit code 1" 1 "$rc"

# 8. docker not in PATH → exit 127 with diagnostic
# Shadow the `command` builtin so `command -v docker` returns non-zero,
# simulating an environment where docker is absent from PATH.
echo ""
echo "docker_alias: docker not in PATH"
output=$(
    command() {
        if [[ "${1:-}" == "-v" && "${2:-}" == "docker" ]]; then return 1; fi
        builtin command "$@"
    }
    export -f command
    docker_alias /app myimage 2>&1
) || true
assert_contains "no-docker: stderr message" "docker is not installed" "$output"

rc=0
(
    command() {
        if [[ "${1:-}" == "-v" && "${2:-}" == "docker" ]]; then return 1; fi
        builtin command "$@"
    }
    export -f command
    docker_alias /app myimage >/dev/null 2>&1
) || rc=$?
assert_exit "no-docker: exit code 127" 127 "$rc"

# ── summary ───────────────────────────────────────────────────────────────────
echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"
echo ""
[[ "$FAIL" -eq 0 ]]

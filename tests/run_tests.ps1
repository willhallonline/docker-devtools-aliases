#Requires -Version 5.1
# Minimal test harness for docker-devtools.ps1
# Usage: pwsh tests/run_tests.ps1 (or powershell.exe on Windows)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$script:Pass = 0
$script:Fail = 0

# ── helpers ──────────────────────────────────────────────────────────────────

function _pass([string]$desc) {
    Write-Host "  PASS  $desc" -ForegroundColor Green
    $script:Pass++
}

function _fail([string]$desc, [string]$reason) {
    Write-Host "  FAIL  $desc" -ForegroundColor Red
    Write-Host "  -> $reason"
    $script:Fail++
}

function assert-eq([string]$desc, $expected, $actual) {
    if ($actual -eq $expected) { _pass $desc } else { _fail $desc "expected '$expected', got '$actual'" }
}

function assert-contains([string]$desc, [string]$needle, [string]$haystack) {
    if ($haystack -like "*$needle*") { _pass $desc } else { _fail $desc "expected to contain '$needle' in: $haystack" }
}

function assert-not-contains([string]$desc, [string]$needle, [string]$haystack) {
    if ($haystack -notlike "*$needle*") { _pass $desc } else { _fail $desc "did not expect to contain '$needle' in: $haystack" }
}

function assert-line-eq([string]$desc, [int]$lineNo, [string]$expected, [string[]]$actualLines) {
    $actual = $actualLines[$lineNo - 1]
    if ($actual -eq $expected) { _pass $desc } else { _fail $desc "expected line ${lineNo} to be '$expected', got '$actual'" }
}

# ── docker stub ──────────────────────────────────────────────────────────────
# Intercepts docker calls; writes argv to a script-scoped array so tests can
# assert on it without spawning real containers.

$script:StubArgs = @()
function docker { $script:StubArgs = $args }
function _read-stub { return $script:StubArgs }

# ── load the code under test ──────────────────────────────────────────────────
# Build a minimal replica of the repo layout under a temp dir so we can dot
# source docker-devtools.ps1 in isolation, with stubbed alias sub-files.

$TmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid())
New-Item -ItemType Directory -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TmpDir 'php') | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TmpDir 'js') | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TmpDir 'python') | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TmpDir 'java') | Out-Null
Copy-Item (Join-Path $RepoRoot 'docker-devtools.ps1') $TmpDir
New-Item -ItemType File -Path (Join-Path $TmpDir 'php/docker-php-devtools.ps1') | Out-Null
New-Item -ItemType File -Path (Join-Path $TmpDir 'js/docker-js-devtools.ps1') | Out-Null
New-Item -ItemType File -Path (Join-Path $TmpDir 'python/docker-python-devtools.ps1') | Out-Null
New-Item -ItemType File -Path (Join-Path $TmpDir 'java/docker-java-devtools.ps1') | Out-Null

try {
    . (Join-Path $TmpDir 'docker-devtools.ps1')

    # ── tests ─────────────────────────────────────────────────────────────

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: argument validation'

    try {
        Invoke-DockerAlias -WorkingDir '' -Image ''
        $errVar = ''
    } catch {
        $errVar = $_.Exception.Message
    }
    assert-contains 'too-few-args: stderr message' 'requires a working directory' $errVar

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: basic argv construction'
    Push-Location $TmpDir
    Invoke-DockerAlias /app myimage:tag mycommand --flag value
    Pop-Location
    $argv = _read-stub
    assert-eq 'basic: run sub-command' 'run' $argv[0]
    assert-eq 'basic: tty flag' '-it' $argv[1]
    assert-eq 'basic: --rm flag' '--rm' $argv[2]
    assert-contains 'basic: volume mount contains working_dir' '/app' ($argv -join ' ')
    assert-contains 'basic: image present' 'myimage:tag' ($argv -join ' ')
    assert-contains 'basic: passthrough cmd' 'mycommand' ($argv -join ' ')
    assert-contains 'basic: passthrough flag' '--flag' ($argv -join ' ')
    assert-contains 'basic: passthrough value' 'value' ($argv -join ' ')
    assert-not-contains 'basic: host user mapping disabled by default' '--user' ($argv -join ' ')

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: -w working directory'
    Push-Location $TmpDir
    Invoke-DockerAlias /work/dir myimage:tag
    Pop-Location
    $argv = _read-stub
    assert-contains 'workdir: -w present' '-w' ($argv -join ' ')
    assert-contains 'workdir: correct path' '/work/dir' ($argv -join ' ')

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: argument passthrough'
    Push-Location $TmpDir
    Invoke-DockerAlias /app myimage arg1 'arg with spaces' arg3
    Pop-Location
    $argv = _read-stub
    assert-contains 'passthrough: arg1' 'arg1' ($argv -join ' ')
    assert-contains 'passthrough: arg with spaces' 'arg with spaces' ($argv -join ' ')
    assert-contains 'passthrough: arg3' 'arg3' ($argv -join ' ')

    Write-Host ''
    Write-Host 'alias loading: sub-files sourced without error'
    $cmd = Get-Command Invoke-DockerAlias -ErrorAction SilentlyContinue
    assert-eq 'alias-load: Invoke-DockerAlias still defined after source' $true ($null -ne $cmd)

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: DOCKER_DEVTOOLS_EXTRA_ARGS'
    $env:DOCKER_DEVTOOLS_EXTRA_ARGS = '--network host --pull always'
    Push-Location $TmpDir
    Invoke-DockerAlias /app myimage:tag
    Pop-Location
    Remove-Item Env:\DOCKER_DEVTOOLS_EXTRA_ARGS
    $argv = _read-stub
    assert-contains 'extra-args: network flag present' '--network' ($argv -join ' ')
    assert-contains 'extra-args: network value present' 'host' ($argv -join ' ')
    assert-contains 'extra-args: pull flag present' '--pull' ($argv -join ' ')
    assert-contains 'extra-args: pull value present' 'always' ($argv -join ' ')
    assert-eq 'extra-args: image is last' 'myimage:tag' $argv[-1]

    if (-not $IsWindows) {
        Write-Host ''
        Write-Host 'Invoke-DockerAlias: DOCKER_DEVTOOLS_MAP_HOST_USER'
        $env:DOCKER_DEVTOOLS_MAP_HOST_USER = 'true'
        Push-Location $TmpDir
        Invoke-DockerAlias /app myimage:tag
        Pop-Location
        Remove-Item Env:\DOCKER_DEVTOOLS_MAP_HOST_USER
        $argv = _read-stub
        $uid = (id -u); $gid = (id -g)
        assert-contains 'map-host-user: user flag present' '--user' ($argv -join ' ')
        assert-contains 'map-host-user: uid gid present' "${uid}:${gid}" ($argv -join ' ')
    }

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: DOCKER_DEVTOOLS_TTY=never'
    $env:DOCKER_DEVTOOLS_TTY = 'never'
    Push-Location $TmpDir
    Invoke-DockerAlias /app myimage:tag
    Pop-Location
    Remove-Item Env:\DOCKER_DEVTOOLS_TTY
    $argv = _read-stub
    assert-not-contains 'tty-never: tty flag absent' '-it' ($argv -join ' ')
    assert-eq 'tty-never: --rm becomes second line' '--rm' $argv[1]

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: invalid runtime config'
    $env:DOCKER_DEVTOOLS_TTY = 'invalid'
    try {
        Invoke-DockerAlias /app myimage:tag
        $errVar = ''
    } catch {
        $errVar = $_.Exception.Message
    }
    Remove-Item Env:\DOCKER_DEVTOOLS_TTY
    assert-contains 'invalid-tty: stderr message' 'invalid DOCKER_DEVTOOLS_TTY value' $errVar

    $env:DOCKER_DEVTOOLS_MAP_HOST_USER = 'maybe'
    try {
        Invoke-DockerAlias /app myimage:tag
        $errVar = ''
    } catch {
        $errVar = $_.Exception.Message
    }
    Remove-Item Env:\DOCKER_DEVTOOLS_MAP_HOST_USER
    assert-contains 'invalid-bool: stderr message' 'invalid DOCKER_DEVTOOLS_MAP_HOST_USER value' $errVar

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: --entrypoint override'
    Push-Location $TmpDir
    Invoke-DockerAlias /app myimage:tag --entrypoint mogrify input.jpg -resize 50%
    Pop-Location
    $argv = _read-stub
    assert-contains 'entrypoint: flag present' '--entrypoint' ($argv -join ' ')
    assert-contains 'entrypoint: value present' 'mogrify' ($argv -join ' ')
    assert-contains 'entrypoint: passthrough args preserved' 'input.jpg' ($argv -join ' ')
    assert-contains 'entrypoint: passthrough flag preserved' '-resize' ($argv -join ' ')

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: --entrypoint missing value'
    try {
        Invoke-DockerAlias /app myimage:tag --entrypoint
        $errVar = ''
    } catch {
        $errVar = $_.Exception.Message
    }
    assert-contains 'entrypoint-missing: stderr message' '--entrypoint requires a value' $errVar

    Write-Host ''
    Write-Host 'Invoke-DockerAlias: single-dash passthrough flags (e.g. cwebp -o)'
    Push-Location $TmpDir
    Invoke-DockerAlias /images myimage:tag -o output.webp
    Pop-Location
    $argv = _read-stub
    assert-contains 'passthrough-dash: -o flag preserved' '-o' ($argv -join ' ')
    assert-contains 'passthrough-dash: value preserved' 'output.webp' ($argv -join ' ')
}
finally {
    Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
}

# ── summary ───────────────────────────────────────────────────────────────────
Write-Host ''
Write-Host "Results: $($script:Pass) passed, $($script:Fail) failed"
Write-Host ''

if ($script:Fail -ne 0) { exit 1 }
exit 0

#Requires -Version 5.1
# Docker DevTools — PowerShell entry point
#
# Add to your PowerShell profile ($PROFILE):
#   . "$HOME/.docker-devtools/docker-devtools.ps1"

function Test-DockerDevToolsBool {
    <#
        .SYNOPSIS
        Parses a truthy/falsy environment-variable style string.
        Returns $true, $false, or $null (and writes an error) if the value is invalid.
    #>
    param(
        [Parameter(Mandatory)] [string] $Name,
        [Parameter()] [string] $Value
    )

    $normalized = if ($null -eq $Value) { '' } else { $Value.ToLowerInvariant() }

    switch ($normalized) {
        { $_ -in @('1', 'true', 'yes', 'on') }   { return $true }
        { $_ -in @('', '0', 'false', 'no', 'off') } { return $false }
        default {
            Write-Error "docker-devtools: invalid $Name value '$Value' (expected true or false)."
            return $null
        }
    }
}

function Invoke-DockerAlias {
    <#
        .SYNOPSIS
        Runs a tool inside a Docker container, mounting the current directory.

        .DESCRIPTION
        PowerShell equivalent of the docker_alias bash function. Mounts $PWD into
        the container at -WorkingDir, runs -Image (optionally with a command),
        and forwards any remaining arguments to the containerized process.
        An optional "--entrypoint <name>" pair immediately after the image
        overrides the container's baked-in entrypoint.

        This is intentionally a "basic" (non-advanced) function — it has no
        [Parameter()]/[CmdletBinding()] attributes — so that PowerShell does not
        layer on the common parameters (-ErrorAction, -OutVariable, etc.). If it
        were advanced, single-dash passthrough flags like "-o" (used by cwebp)
        would be ambiguously prefix-matched against "-OutVariable"/"-OutBuffer"
        and rejected instead of being forwarded to the containerized process.
    #>
    param($WorkingDir, $Image)
    $Rest = $args

    if (-not $WorkingDir -or -not $Image) {
        Write-Error 'docker-devtools: Invoke-DockerAlias requires a working directory and image.'
        return
    }

    # Optional --entrypoint <name> immediately after the image, used to
    # override a container's baked-in entrypoint (e.g. selecting a specific
    # binary out of a multi-tool image).
    $entrypoint = $null
    if ($Rest -and $Rest.Count -gt 0 -and $Rest[0] -eq '--entrypoint') {
        if ($Rest.Count -lt 2 -or [string]::IsNullOrEmpty($Rest[1])) {
            Write-Error 'docker-devtools: --entrypoint requires a value.'
            return
        }
        $entrypoint = $Rest[1]
        $Rest = if ($Rest.Count -gt 2) { $Rest[2..($Rest.Count - 1)] } else { @() }
    }

    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Error 'docker-devtools: docker is not installed or not in PATH.'
        return
    }

    $ttyMode = if ($env:DOCKER_DEVTOOLS_TTY) { $env:DOCKER_DEVTOOLS_TTY } else { 'always' }

    $dockerArgs = [System.Collections.Generic.List[string]]::new()
    $dockerArgs.Add('run')

    switch ($ttyMode) {
        'always' { $dockerArgs.Add('-it') }
        'auto' {
            if (-not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected) {
                $dockerArgs.Add('-it')
            }
        }
        'never' { }
        default {
            Write-Error "docker-devtools: invalid DOCKER_DEVTOOLS_TTY value '$ttyMode' (expected always, auto, or never)."
            return
        }
    }

    $dockerArgs.Add('--rm')
    $dockerArgs.Add('-v')
    $dockerArgs.Add("$($PWD.Path):$WorkingDir")
    $dockerArgs.Add('-w')
    $dockerArgs.Add($WorkingDir)

    if ($entrypoint) {
        $dockerArgs.Add('--entrypoint')
        $dockerArgs.Add($entrypoint)
    }

    $mapHostUser = Test-DockerDevToolsBool -Name 'DOCKER_DEVTOOLS_MAP_HOST_USER' -Value $env:DOCKER_DEVTOOLS_MAP_HOST_USER
    if ($null -eq $mapHostUser) { return }
    if ($mapHostUser -and -not $IsWindows) {
        $uid = (id -u)
        $gid = (id -g)
        $dockerArgs.Add('--user')
        $dockerArgs.Add("${uid}:${gid}")
    }

    if ($env:DOCKER_DEVTOOLS_EXTRA_ARGS) {
        $extraArgs = $env:DOCKER_DEVTOOLS_EXTRA_ARGS -split '\s+' | Where-Object { $_ -ne '' }
        foreach ($a in $extraArgs) { $dockerArgs.Add($a) }
    }

    $dockerArgs.Add($Image)
    if ($Rest) { foreach ($a in $Rest) { $dockerArgs.Add($a) } }

    & docker @dockerArgs
}

$script:DockerDevToolsDir = $PSScriptRoot

# NOTE: dot-sourcing must happen directly in this script's scope (not inside a
# function) so the functions/aliases they define land in the caller's scope.
foreach ($relativePath in @('php/docker-php-devtools.ps1', 'js/docker-js-devtools.ps1')) {
    $alias_file = Join-Path $script:DockerDevToolsDir $relativePath

    if (-not (Test-Path -LiteralPath $alias_file)) {
        Write-Error "docker-devtools: missing required alias file: $alias_file"
        return
    }

    . $alias_file
}

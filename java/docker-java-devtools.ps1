# Docker DevTools — Java (PowerShell)

# Java runtime & package management
#
# Eclipse Temurin (official Adoptium image, LTS)
function java-docker { Invoke-DockerAlias /app eclipse-temurin:21-jdk java @args }
function javac-docker { Invoke-DockerAlias /app eclipse-temurin:21-jdk javac @args }
function java-bash-docker { Invoke-DockerAlias /app eclipse-temurin:21-jdk /bin/bash @args }

# Maven (official image, pinned to Temurin 21 LTS)
function mvn-docker { Invoke-DockerAlias /app maven:3-eclipse-temurin-21 mvn @args }

# Gradle (official image, pinned to JDK 21 LTS)
function gradle-docker { Invoke-DockerAlias /app gradle:jdk21 gradle @args }

# Java Linters & Static Analysis
#
# There is no actively-maintained, purpose-built image for running these
# tools standalone, so instead of trusting a random third-party image (or
# building/maintaining our own), each function downloads the project's own
# official release artifact into an ephemeral eclipse-temurin container and
# runs it directly. This costs a few extra seconds per invocation for the
# download, which isn't cached between runs since containers are removed
# with --rm.
#
# Note: the "sh -c 'script' -- arg1 arg2..." args are built into an array
# and splatted (@cmdArgs) rather than passed as literal tokens on the call
# line. PowerShell's parser strips a bare "--" token from a command's
# argument list (treating it as an "end of named parameters" marker) even
# for ordinary functions, which would silently drop the "$0" placeholder and
# shift every real argument passed to the containerized script. Building the
# array as data and splatting it avoids that re-parsing entirely.
#
# Versions are pinned below; bump them here to upgrade.
$script:CheckstyleVersion = '13.7.0'
$script:SpotBugsVersion = '4.10.2'
$script:PmdVersion = '7.26.0'
$script:GoogleJavaFormatVersion = '1.35.0'

# Checkstyle — style/convention checker (single runnable "-all" jar)
function checkstyle-docker {
    $url = "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-$script:CheckstyleVersion/checkstyle-$script:CheckstyleVersion-all.jar"
    $scriptCmd = "curl -fsSL -o /tmp/checkstyle.jar `"$url`" 1>&2 && exec java -jar /tmp/checkstyle.jar `"`$@`""
    $cmdArgs = @('sh', '-c', $scriptCmd, '--') + $args
    Invoke-DockerAlias /app eclipse-temurin:21-jre @cmdArgs
}

# SpotBugs — static analysis for bug patterns in compiled .class files
function spotbugs-docker {
    $url = "https://github.com/spotbugs/spotbugs/releases/download/$script:SpotBugsVersion/spotbugs-$script:SpotBugsVersion.tgz"
    $scriptCmd = "curl -fsSL -o /tmp/spotbugs.tgz `"$url`" 1>&2 && tar xzf /tmp/spotbugs.tgz -C /tmp 1>&2 && exec bash /tmp/spotbugs-$script:SpotBugsVersion/bin/spotbugs `"`$@`""
    $cmdArgs = @('sh', '-c', $scriptCmd, '--') + $args
    Invoke-DockerAlias /app eclipse-temurin:21-jdk @cmdArgs
}

# PMD — static source code analyzer (rule-based, source-level like Checkstyle)
function pmd-docker {
    $url = "https://github.com/pmd/pmd/releases/download/pmd_releases/$script:PmdVersion/pmd-dist-$script:PmdVersion-bin.zip"
    $scriptCmd = "curl -fsSL -o /tmp/pmd.zip `"$url`" 1>&2 && (cd /tmp && jar xf /tmp/pmd.zip) 1>&2 && exec bash /tmp/pmd-bin-$script:PmdVersion/bin/pmd `"`$@`""
    $cmdArgs = @('sh', '-c', $scriptCmd, '--') + $args
    Invoke-DockerAlias /app eclipse-temurin:21-jdk @cmdArgs
}

# google-java-format — opinionated code formatter (requires a JDK, not a JRE)
function google-java-format-docker {
    $url = "https://github.com/google/google-java-format/releases/download/v$script:GoogleJavaFormatVersion/google-java-format-$script:GoogleJavaFormatVersion-all-deps.jar"
    $scriptCmd = "curl -fsSL -o /tmp/google-java-format.jar `"$url`" 1>&2 && exec java -jar /tmp/google-java-format.jar `"`$@`""
    $cmdArgs = @('sh', '-c', $scriptCmd, '--') + $args
    Invoke-DockerAlias /app eclipse-temurin:21-jdk @cmdArgs
}

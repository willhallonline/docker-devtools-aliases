# Java runtime & package management
#
# Eclipse Temurin (official Adoptium image, LTS)
alias java-docker="docker_alias /app eclipse-temurin:21-jdk java"
alias javac-docker="docker_alias /app eclipse-temurin:21-jdk javac"
alias java-bash-docker="docker_alias /app eclipse-temurin:21-jdk /bin/bash"

# Maven (official image, pinned to Temurin 21 LTS)
alias mvn-docker="docker_alias /app maven:3-eclipse-temurin-21 mvn"

# Gradle (official image, pinned to JDK 21 LTS)
alias gradle-docker="docker_alias /app gradle:jdk21 gradle"

# Java Linters & Static Analysis
#
# There is no actively-maintained, purpose-built image for running these
# tools standalone, so instead of trusting a random third-party image (or
# building/maintaining our own), each alias downloads the project's own
# official release artifact into an ephemeral eclipse-temurin container and
# runs it directly. This costs a few extra seconds per invocation for the
# download, which isn't cached between runs since containers are removed
# with --rm.
#
# Versions are pinned below; bump them here to upgrade.
_checkstyle_version="13.7.0"
_spotbugs_version="4.10.2"
_pmd_version="7.26.0"
_google_java_format_version="1.35.0"

# Checkstyle — style/convention checker (single runnable "-all" jar)
# shellcheck disable=SC2016
alias checkstyle-docker="docker_alias /app eclipse-temurin:21-jre sh -c 'curl -fsSL -o \"/tmp/checkstyle.jar\" \"https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${_checkstyle_version}/checkstyle-${_checkstyle_version}-all.jar\" 1>&2 && exec java -jar \"/tmp/checkstyle.jar\" \"\$@\"' --"

# SpotBugs — static analysis for bug patterns in compiled .class files
# shellcheck disable=SC2016
alias spotbugs-docker="docker_alias /app eclipse-temurin:21-jdk sh -c 'curl -fsSL -o \"/tmp/spotbugs.tgz\" \"https://github.com/spotbugs/spotbugs/releases/download/${_spotbugs_version}/spotbugs-${_spotbugs_version}.tgz\" 1>&2 && tar xzf \"/tmp/spotbugs.tgz\" -C /tmp 1>&2 && exec bash \"/tmp/spotbugs-${_spotbugs_version}/bin/spotbugs\" \"\$@\"' --"

# PMD — static source code analyzer (rule-based, source-level like Checkstyle)
# shellcheck disable=SC2016
alias pmd-docker="docker_alias /app eclipse-temurin:21-jdk sh -c 'curl -fsSL -o \"/tmp/pmd.zip\" \"https://github.com/pmd/pmd/releases/download/pmd_releases/${_pmd_version}/pmd-dist-${_pmd_version}-bin.zip\" 1>&2 && (cd /tmp && jar xf \"/tmp/pmd.zip\") 1>&2 && exec bash \"/tmp/pmd-bin-${_pmd_version}/bin/pmd\" \"\$@\"' --"

# google-java-format — opinionated code formatter (requires a JDK, not a JRE)
# shellcheck disable=SC2016
alias google-java-format-docker="docker_alias /app eclipse-temurin:21-jdk sh -c 'curl -fsSL -o \"/tmp/google-java-format.jar\" \"https://github.com/google/google-java-format/releases/download/v${_google_java_format_version}/google-java-format-${_google_java_format_version}-all-deps.jar\" 1>&2 && exec java -jar \"/tmp/google-java-format.jar\" \"\$@\"' --"

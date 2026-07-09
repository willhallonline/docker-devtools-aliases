# Docker DevTools — Internet tools (PowerShell)
# Not sourced automatically; source explicitly if needed:
#   . "$HOME/.docker-devtools/internet/docker-internet-devtools.ps1"
#
# The server-style functions (Start-Floci, Start-LocalStack, Start-Prometheus,
# Start-Grafana, Start-Nginx, Start-Apache, Start-PostgreSql, Start-MariaDb)
# start a long-lived, detached (-d --rm) container via Invoke-DockerServiceAlias
# instead of the foreground Invoke-DockerAlias wrapper used by the CLI tools.
# Stop them with `docker stop <container-name>`.

# ── Infrastructure as Code ────────────────────────────────────────────────────

# Terraform (official image) — usage: terraform-docker init / plan / apply
function terraform-docker { Invoke-DockerAlias /app hashicorp/terraform:latest @args }

# Ansible (willhallonline/ansible) — usage: ansible-docker --version
#                                            ansible-playbook-docker site.yml
function ansible-docker { Invoke-DockerAlias /ansible/playbooks willhallonline/ansible:latest ansible @args }
function ansible-playbook-docker { Invoke-DockerAlias /ansible/playbooks willhallonline/ansible:latest ansible-playbook @args }

# Pulumi (official image) — usage: pulumi-docker preview
function pulumi-docker { Invoke-DockerAlias /app pulumi/pulumi:latest pulumi @args }

# ── Cloud CLIs ────────────────────────────────────────────────────────────────

# Azure CLI (official image, entrypoint is already `az`) — usage: az-docker login
function az-docker { Invoke-DockerAlias /app mcr.microsoft.com/azure-cli:latest @args }

# AWS CLI (official image, entrypoint is already `aws`) — usage: aws-docker s3 ls
function aws-docker { Invoke-DockerAlias /aws amazon/aws-cli:latest @args }

# Google Cloud CLI (official image, no fixed entrypoint) — usage: gcloud-docker version
function gcloud-docker { Invoke-DockerAlias /app google/cloud-sdk:latest gcloud @args }

# ── Local cloud emulators (detached services) ────────────────────────────────

# Floci — lightweight AWS local emulator. https://github.com/floci-io/floci
# usage: floci-docker            (start)
#        docker stop devtools-floci
function floci-docker {
    Invoke-DockerServiceAlias devtools-floci floci/floci:latest -ServiceArgs @('-p', '4566:4566', '-v', '/var/run/docker.sock:/var/run/docker.sock') @args
}

# LocalStack — AWS local emulator. https://github.com/localstack/localstack
# usage: localstack-docker       (start)
#        docker stop devtools-localstack
function localstack-docker {
    Invoke-DockerServiceAlias devtools-localstack localstack/localstack:latest -ServiceArgs @('-p', '4566:4566', '-v', '/var/run/docker.sock:/var/run/docker.sock') @args
}

# ── Monitoring ────────────────────────────────────────────────────────────────

# Prometheus (official image) — reads ./prometheus.yml from the current directory
# usage: prometheus-docker       (start, expects ./prometheus.yml)
#        docker stop devtools-prometheus
function prometheus-docker {
    Invoke-DockerServiceAlias devtools-prometheus prom/prometheus:latest -ServiceArgs @('-p', '9090:9090', '-v', "$($PWD.Path):/etc/prometheus") @args
}

# Grafana (official image) — usage: grafana-docker (start, http://localhost:3000, admin/admin)
#        docker stop devtools-grafana
function grafana-docker {
    Invoke-DockerServiceAlias devtools-grafana grafana/grafana:latest -ServiceArgs @('-p', '3000:3000') @args
}

# ── Web servers ───────────────────────────────────────────────────────────────

# Nginx (official image) — serves the current directory read-only on :8080
# usage: nginx-docker             (start, http://localhost:8080)
#        docker stop devtools-nginx
function nginx-docker {
    Invoke-DockerServiceAlias devtools-nginx nginx:latest -ServiceArgs @('-p', '8080:80', '-v', "$($PWD.Path):/usr/share/nginx/html:ro") @args
}

# Apache httpd (official image) — serves the current directory read-only on :8081
# usage: apache-docker            (start, http://localhost:8081)
#        docker stop devtools-apache
function apache-docker {
    Invoke-DockerServiceAlias devtools-apache httpd:latest -ServiceArgs @('-p', '8081:80', '-v', "$($PWD.Path):/usr/local/apache2/htdocs:ro") @args
}

# ── Databases ─────────────────────────────────────────────────────────────────

# PostgreSQL (official image) — default password "postgres" (override via
# $env:DOCKER_DEVTOOLS_EXTRA_ARGS = "-e POSTGRES_PASSWORD=..."). Data persists
# in the named volume "devtools-postgresql-data" (not the current directory).
# usage: postgresql-docker        (start, localhost:5432)
#        docker stop devtools-postgresql
function postgresql-docker {
    Invoke-DockerServiceAlias devtools-postgresql postgres:latest -ServiceArgs @('-e', 'POSTGRES_PASSWORD=postgres', '-p', '5432:5432', '-v', 'devtools-postgresql-data:/var/lib/postgresql/data') @args
}

# MariaDB (official image) — default root password "mariadb" (override via
# $env:DOCKER_DEVTOOLS_EXTRA_ARGS = "-e MARIADB_ROOT_PASSWORD=..."). Data
# persists in the named volume "devtools-mariadb-data" (not the current directory).
# usage: mariadb-docker           (start, localhost:3306)
#        docker stop devtools-mariadb
function mariadb-docker {
    Invoke-DockerServiceAlias devtools-mariadb mariadb:latest -ServiceArgs @('-e', 'MARIADB_ROOT_PASSWORD=mariadb', '-p', '3306:3306', '-v', 'devtools-mariadb-data:/var/lib/mysql') @args
}

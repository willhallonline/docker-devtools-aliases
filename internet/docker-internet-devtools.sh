# Internet Tools
#
# Aliases for infrastructure-as-code CLIs, cloud CLIs, local cloud emulators,
# and common server containers. This file is NOT sourced automatically —
# add it explicitly if you need it:
#
#   source ~/.docker-devtools/docker-devtools.sh
#   source ~/.docker-devtools/internet/docker-internet-devtools.sh
#
# The server-style aliases (localstack-docker, floci-docker, prometheus-docker,
# grafana-docker, nginx-docker, apache-docker, postgresql-docker,
# mariadb-docker) start a long-lived, detached (-d --rm) container via
# docker_service_alias instead of the foreground docker_alias wrapper used by
# the CLI tools. Stop them with `docker stop <container-name>`.

# ── Infrastructure as Code ────────────────────────────────────────────────────

# Terraform (official image) — usage: terraform-docker init / plan / apply
alias terraform-docker="docker_alias /app hashicorp/terraform:latest"

# Ansible (willhallonline/ansible) — usage: ansible-docker --version
#                                            ansible-playbook-docker site.yml
alias ansible-docker="docker_alias /ansible/playbooks willhallonline/ansible:latest ansible"
alias ansible-playbook-docker="docker_alias /ansible/playbooks willhallonline/ansible:latest ansible-playbook"

# Pulumi (official image) — usage: pulumi-docker preview
alias pulumi-docker="docker_alias /app pulumi/pulumi:latest pulumi"

# ── Cloud CLIs ────────────────────────────────────────────────────────────────

# Azure CLI (official image, entrypoint is already `az`) — usage: az-docker login
alias az-docker="docker_alias /app mcr.microsoft.com/azure-cli:latest"

# AWS CLI (official image, entrypoint is already `aws`) — usage: aws-docker s3 ls
alias aws-docker="docker_alias /aws amazon/aws-cli:latest"

# Google Cloud CLI (official image, no fixed entrypoint) — usage: gcloud-docker version
alias gcloud-docker="docker_alias /app google/cloud-sdk:latest gcloud"

# ── Local cloud emulators (detached services) ────────────────────────────────

# Floci — lightweight AWS local emulator. https://github.com/floci-io/floci
# Emulates AWS services on port 4566 (same convention as LocalStack).
# usage: floci-docker            (start)
#        docker stop devtools-floci
alias floci-docker="docker_service_alias devtools-floci floci/floci:latest -p 4566:4566 -v /var/run/docker.sock:/var/run/docker.sock --"

# LocalStack — AWS local emulator. https://github.com/localstack/localstack
# usage: localstack-docker       (start)
#        docker stop devtools-localstack
alias localstack-docker="docker_service_alias devtools-localstack localstack/localstack:latest -p 4566:4566 -v /var/run/docker.sock:/var/run/docker.sock --"

# ── Monitoring ────────────────────────────────────────────────────────────────

# Prometheus (official image) — reads ./prometheus.yml from the current directory
# usage: prometheus-docker       (start, expects ./prometheus.yml)
#        docker stop devtools-prometheus
alias prometheus-docker="docker_service_alias devtools-prometheus prom/prometheus:latest -p 9090:9090 -v \"\$PWD\":/etc/prometheus --"

# Grafana (official image) — usage: grafana-docker (start, http://localhost:3000, admin/admin)
#        docker stop devtools-grafana
alias grafana-docker="docker_service_alias devtools-grafana grafana/grafana:latest -p 3000:3000 --"

# ── Web servers ───────────────────────────────────────────────────────────────

# Nginx (official image) — serves the current directory read-only on :8080
# usage: nginx-docker             (start, http://localhost:8080)
#        docker stop devtools-nginx
alias nginx-docker="docker_service_alias devtools-nginx nginx:latest -p 8080:80 -v \"\$PWD\":/usr/share/nginx/html:ro --"

# Apache httpd (official image) — serves the current directory read-only on :8081
# usage: apache-docker            (start, http://localhost:8081)
#        docker stop devtools-apache
alias apache-docker="docker_service_alias devtools-apache httpd:latest -p 8081:80 -v \"\$PWD\":/usr/local/apache2/htdocs:ro --"

# ── Databases ─────────────────────────────────────────────────────────────────

# PostgreSQL (official image) — default password "postgres" (override via
# DOCKER_DEVTOOLS_EXTRA_ARGS="-e POSTGRES_PASSWORD=..."). Data persists in the
# named volume "devtools-postgresql-data" (not the current directory).
# usage: postgresql-docker        (start, localhost:5432)
#        docker stop devtools-postgresql
alias postgresql-docker="docker_service_alias devtools-postgresql postgres:latest -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v devtools-postgresql-data:/var/lib/postgresql/data --"

# MariaDB (official image) — default root password "mariadb" (override via
# DOCKER_DEVTOOLS_EXTRA_ARGS="-e MARIADB_ROOT_PASSWORD=..."). Data persists in
# the named volume "devtools-mariadb-data" (not the current directory).
# usage: mariadb-docker           (start, localhost:3306)
#        docker stop devtools-mariadb
alias mariadb-docker="docker_service_alias devtools-mariadb mariadb:latest -e MARIADB_ROOT_PASSWORD=mariadb -p 3306:3306 -v devtools-mariadb-data:/var/lib/mysql --"

# Internet Tools
#
# Aliases for infrastructure-as-code CLIs and cloud CLIs. This file is NOT
# sourced automatically — add it explicitly if you need it:
#
#   source ~/.docker-devtools/docker-devtools.sh
#   source ~/.docker-devtools/internet/docker-internet-devtools.sh

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

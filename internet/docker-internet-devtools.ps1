# Docker DevTools — Internet tools (PowerShell)
# Not sourced automatically; source explicitly if needed:
#   . "$HOME/.docker-devtools/internet/docker-internet-devtools.ps1"

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

# ── Kubernetes ────────────────────────────────────────────────────────────────

# kubectl (official image) — usage: kubectl-docker get pods
function kubectl-docker { Invoke-DockerAlias /app bitnami/kubectl:latest @args }

# Helm (official image) — usage: helm-docker install my-release ./chart
function helm-docker { Invoke-DockerAlias /app alpine/helm:latest @args }

# Packer (official image) — usage: packer-docker build template.pkr.hcl
function packer-docker { Invoke-DockerAlias /app hashicorp/packer:latest @args }

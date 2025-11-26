# Terraform Infra — Multi-environment Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D0.12-blue)](https://www.terraform.io/) [![License](https://img.shields.io/badge/License-MIT-green)](#license)

A concise, friendly guide to the Terraform infrastructure in this repository: environments, modules, architecture, common pitfalls we encountered while building the infra, and recommended next steps.

**Table of Contents**
- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Repository Layout](#repository-layout)
- [Quick Start](#quick-start)
- [Backend (recommended)](#backend-recommended)
- [Pitfalls & Resolutions](#pitfalls--resolutions)
- [Why this README exists](#why-this-readme-exists)
- [Next Steps & Improvements](#next-steps--improvements)
- [Contributing](#contributing)

## Project Overview

This repository contains Terraform code to provision a VPC-based architecture with modules for `ec2`, `rds`, and `VPC`. It supports multiple environments under `Environment/` (for example `dev` and `prod`) and aims to keep reusable logic inside `modules/`.

## Architecture

High-level diagram (each environment gets its own instance of this pattern):

```
                       Internet
                          |
                          v
                    [Internet Gateway]
                          |
                          v
                        [VPC]
               /----------|-----------\
       Public Subnet   Private Subnet   Private Subnet
         (Bastion)     (App Servers)     (RDS - no public access)
             |               |                  |
         [EC2 - public]  [EC2 - private]    [RDS - private]
                                 |
                          [NAT Gateway]
```

- VPC: subnets, route tables, IGW, NAT
- EC2 module: instances, security groups, IAM role attachment
- RDS module: managed database in private subnets

## Repository Layout

- `main.tf`, `provider.tf`, `variables.tf`, `terraform.tfvars` — root orchestration and shared variables
- `Environment/` — environment-specific stacks and states
  - `dev/` — development environment (includes `terraform.tfstate` in your local copy; do not commit)
  - `prod/` — production environment
- `modules/` — reusable modules
  - `ec2/` — EC2 resources
  - `rds/` — RDS resources
  - `VPC/` — VPC resources

## Quick Start

1. Install Terraform (match version pinned in `required_version` if present).

2. Avoid running in repository root unless intended — pick the environment folder or the root depending on design.

Initialize Terraform:

```powershell
cd .\Environment\dev
terraform init
```

Validate and create a plan:

```powershell
terraform validate
terraform plan -out plan.tfplan
```

Apply the plan:

```powershell
terraform apply plan.tfplan
```

Destroy (when needed):

```powershell
terraform destroy
```

## Backend (recommended)

Local `*.tfstate` files are present in `Environment/dev/` in this workspace. It is strongly recommended to configure a remote backend for shared state and locking. Example S3 backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "project-name/env/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

## Pitfalls & Resolutions (what we faced while creating the infra)

- Provider authentication errors
  - Symptom: "could not find provider credentials" or `AccessDenied`.
  - Cause: Missing environment credentials or wrong `profile` in `provider.tf`.
  - Resolution: Set `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` (or configure `aws configure`) and verify `provider.tf` references the correct profile.

- Committed `terraform.tfstate` to repo
  - Symptom: `terraform.tfstate`/backup files in `Environment/dev/` appear in the repo.
  - Cause: State files left in the working tree and not ignored.
  - Resolution: Add the following to `.gitignore` and remove any committed state from git history if needed:

```text
# Terraform
*.tfstate
*.tfstate.backup
.terraform/
```

- Concurrent changes / no locking
  - Symptom: State corruption or conflicting applies.
  - Cause: Local state without locking.
  - Resolution: Configure an S3 backend with a DynamoDB lock table or use Terraform Cloud.

- Insufficient IAM permissions
  - Symptom: `AccessDenied` on resource creation.
  - Cause: The executing IAM principal lacks required permissions.
  - Resolution: Update IAM policies to permit needed actions.

- Resource quotas reached
  - Symptom: API errors complaining about resource limits.
  - Resolution: Request quota increases or lower resource counts for the environment.

- Variable misconfiguration
  - Symptom: `plan` fails due to missing or invalid variables.
  - Resolution: Provide `terraform.tfvars` (or use `-var` flags) and add a `terraform.tfvars.example` to the repo.

## Why this README exists

- Onboarding: Quickly communicates the repo layout and how to run Terraform.
- Safety: Documents sensitive files to avoid accidentally committing state.
- Troubleshooting: Captures the real errors and fixes we faced to speed future work.

## Next Steps & Improvements

- Add or update `.gitignore` to exclude state and `.terraform/`.
- Move state to an S3 backend with DynamoDB locking, or enable Terraform Cloud.
- Add `terraform.tfvars.example` with placeholders (do not include secrets).
- Add GitHub Actions for `terraform fmt`, `terraform validate`, and `terraform plan` to protect branches.

📌 Summary Table
File / Folder	When Created?	Purpose
.terraform/	terraform init	Stores providers, modules
.terraform.lock.hcl	terraform init	Locks provider versions
terraform.tfstate	terraform apply	Tracks actual AWS resource IDs
terraform.tfstate.backup	Auto during apply/destroy	Backup of last state
terraform.tfstate.lock.info	Auto during apply/plan	Prevents simultaneous changes
🧠 Why Terraform Creates These Automatically

Terraform follows a workflow:

1. terraform init

→ Downloads providers
→ Creates .terraform folder
→ Creates .terraform.lock.hcl

2. terraform plan

→ Reads state file
→ Creates a lock file temporarily

3. terraform apply

→ Creates or updates AWS resources
→ Updates terraform.tfstate
→ Writes a backup terraform.tfstate.backup

🔥 Important Best Practices
✔ Save .terraform.lock.hcl to Git

(to ensure plugin version consistency)

❌ DO NOT save terraform.tfstate in Git

(includes secrets like passwords, ARNs, resource IDs)

✔ Use remote state instead of local state

(Example: S3 + DynamoDB)

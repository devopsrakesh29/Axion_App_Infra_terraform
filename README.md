# Azure Infrastructure Terraform Architecture (Axion_App_Infra_terraform)

This repository provides a modular, enterprise-grade Terraform codebase for managing Azure cloud infrastructure across **Development (`dev`)**, **Integration (`int`)**, and **Production (`prod`)** environments.

---

## 📁 Repository Directory Structure

```text
Axion_App_Infra_terraform/
├── .github/
│   └── workflows/
│       └── terraform-ci-cd.yml      # 🚀 Multi-Stage CI/CD Pipeline
├── .gitleaks.toml                   # 🔐 Gitleaks Custom Allowlist Configuration
├── .gitleaksignore                  # 🔐 Gitleaks False-Positive Fingerprint Exclusion
├── modules/                         # 🛠️ Generic Child Modules
│   ├── resource_group/              # Resource Group Module (for_each enabled)
│   ├── vnet/                        # VNet & Subnet Module (dynamic delegation & for_each)
│   ├── managed_identity/            # User-Assigned Managed Identity Module
│   ├── storage_account/             # Storage Account & Blob Container Module
│   ├── key_vault/                   # Key Vault & Access Policy Module
│   ├── acr/                         # Public Azure Container Registry (ACR) Module
│   └── aks/                         # Azure Kubernetes Service (AKS) Module with Greenfield AGIC
│
├── environments/                    # 🌐 Environment Root Modules
│   ├── dev/                         # Dev Environment (VNet 10.0.0.0/16)
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   ├── int/                         # Int Environment (VNet 10.1.0.0/16)
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/                        # Prod Environment (VNet 10.2.0.0/16)
│       ├── provider.tf
│       ├── backend.tf
│       ├── variables.tf
│       ├── main.tf
│       ├── outputs.tf
│       └── terraform.tfvars
│
└── README.md
```

---

## ⚙️ Key Architectural Highlights & Recent Enhancements

### 1. Azure Kubernetes Service (AKS) & Greenfield AGIC
* **Kubernetes Engine**: Upgraded to **Kubernetes `1.34`** across all environments (`dev`, `int`, `prod`).
* **Ingress Controller**: Integrated **Greenfield Azure Application Gateway Ingress Controller (AGIC)** addon (`ingress_application_gateway`).
* **API Server Authorized IPs**: Secured API server access restricted to explicit administrator public IPs (e.g. `122.161.50.13/32`).
* **Non-Overlapping Network Topology**:
  * **AKS Node Subnet**: `10.x.1.0/24`
  * **App Gateway Subnet**: `10.x.2.0/24`
  * **Pod CIDR**: Configured in RFC 6598 CGNAT space (`100.64.0.0/16` for dev, `100.65.0.0/16` for int, `100.66.0.0/16` for prod).
  * **Service CIDR**: Shifted to isolated `172.x.0.0/16` ranges (`172.16.0.0/16` for dev, `172.17.0.0/16` for int, `172.18.0.0/16` for prod) to completely avoid collisions with Azure VNet `10.x.0.0/16` space.

### 2. Azure Key Vault Soft-Delete Protection
* Provider feature flags (`purge_soft_delete_on_destroy = true` & `recover_soft_deleted_key_vaults = true`) enabled in `provider.tf` across all environments.
* Automatically purges or recovers soft-deleted key vaults during sandbox cleanups, preventing *"Key Vault already exists in soft-deleted state"* errors.

---

## 🔐 Scanning, Linting, & Security Tooling

The codebase is protected by automated static analysis, linting, secrets detection, and cost estimation tools:

| Tool | Category | Purpose & Configuration |
| :--- | :--- | :--- |
| **`terraform fmt`** | Formatting | Ensures canonical HCL code formatting and alignment (`terraform fmt -check -recursive`). |
| **TFLint** | Code Quality | Validates Terraform syntax, unreferenced variables, and Azure provider-specific rules. |
| **Checkov** | SAST Security | Scans HCL code against CIS Benchmarks, NIST, and Azure security rules. Configured to fail the pipeline **only on HIGH and CRITICAL** risks (`hard_fail_on: CRITICAL,HIGH`). |
| **Gitleaks CLI** | Secrets Scanning | Uses open-source Gitleaks CLI (`v8.18.2`) to scan git history and files for exposed credentials, configured with `.gitleaks.toml` and `.gitleaksignore` to bypass non-secret GUID false positives. |
| **Infracost** | Cost Estimation | Calculates monthly Azure cloud expenditure per environment prior to provisioning resources using `INFRACOST_API_KEY`. |

---

## 🚀 GitHub Actions CI/CD Pipeline & Job Dependencies

The workflow is defined in [`.github/workflows/terraform-ci-cd.yml`](.github/workflows/terraform-ci-cd.yml) and is triggered via `workflow_dispatch`.

### Pipeline Job Dependency Architecture

```mermaid
flowchart TD
    subgraph Stage 1: Parallel Quality, Security & Cost Scans
        J1[Job 1: lint-and-scan<br/>terraform fmt, tflint, checkov]
        J2[Job 2: secret-scan<br/>Open-Source Gitleaks CLI]
        J3[Job 3: infracost<br/>Infracost Cost Breakdown]
    end

    J1 --> J4
    J2 --> J4
    J3 --> J4

    J4[Job 4: terraform-plan<br/>needs: lint-and-scan, secret-scan, infracost]

    J4 -->|if: github.ref == 'refs/heads/main'| J5[Job 5: terraform-apply<br/>needs: terraform-plan<br/>environment: dev / int / prod]
```

### Job Workflow Summary

1. **Stage 1 (Parallel Scans & Cost Estimation)**:
   - **`lint-and-scan`**: Runs `terraform fmt`, `tflint`, and `checkov`.
   - **`secret-scan`**: Runs `gitleaks` CLI.
   - **`infracost`**: Computes estimated monthly cost.
2. **Stage 2 (Execution Plan)**:
   - **`terraform-plan`**: Depends on `[lint-and-scan, secret-scan, infracost]`. Runs `terraform init`, `validate`, and `plan`.
3. **Stage 3 (Conditional Deployment & Approval Gate)**:
   - **`terraform-apply`**: Depends on `[terraform-plan]`. Runs `terraform apply -auto-approve` **only on the `main` branch** (`github.ref == 'refs/heads/main'`) and binds to the GitHub Environment (`environment: ${{ github.event.inputs.environment }}`) to enforce manual approval gates for `prod`.

---

## 🛠️ Local Execution Instructions

Navigate to the desired environment directory (e.g. `environments/dev/`):

```bash
# 1. Initialize Terraform & Remote Backend
cd environments/dev/
terraform init

# 2. Validate Terraform Configuration
terraform validate

# 3. Preview Execution Plan
terraform plan -var-file="terraform.tfvars"

# 4. Apply Changes to Azure
terraform apply -var-file="terraform.tfvars"
```

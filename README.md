# Azure Infrastructure Terraform Architecture (Axion_App_Infra_terraform)

This repository provides a modular, enterprise-grade Terraform codebase for managing Azure cloud infrastructure across **Development (`dev`)**, **Integration (`int`)**, and **Production (`prod`)** environments.

---

## 📁 Repository Directory Structure

```text
Axion_App_Infra_terraform/
├── modules/                         # 🛠️ Generic Child Modules
│   ├── resource_group/              # Resource Group Module (for_each enabled)
│   ├── vnet/                        # VNet & Subnet Module (dynamic delegation & for_each)
│   ├── managed_identity/            # User Assigned Managed Identity Module
│   ├── storage_account/             # Storage Account & Container Module
│   ├── key_vault/                   # Key Vault & Access Policy Module
│   ├── acr/                         # Public Azure Container Registry (ACR) Module
│   └── aks/                         # Azure Kubernetes Service (AKS) Module (1 System + 1 User Pool)
│
├── environments/                    # 🌐 Environment Root Modules
│   ├── dev/                         # Dev Environment
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars         # Blank values file for user input
│   ├── int/                         # Int Environment
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars         # Blank values file for user input
│   └── prod/                        # Prod Environment
│       ├── provider.tf
│       ├── backend.tf
│       ├── variables.tf
│       ├── main.tf
│       ├── outputs.tf
│       └── terraform.tfvars         # Blank values file for user input
│
└── README.md
```

---

## ⚙️ Key Features & Engineering Highlights

1. **Child & Root Module Architecture**:
   - **Child Modules (`modules/*`)**: Pure, reusable building blocks leveraging `for_each`, `dynamic` blocks, data sources (`data "azurerm_client_config"`), and strict type validation with `optional()` attributes.
   - **Environment Root Modules (`environments/dev/`, `environments/int/`, `environments/prod/`)**: Environment orchestrators calling child modules (`source = "../../modules/..."`) with explicit module dependencies (`depends_on`).

2. **Azure Kubernetes Service (AKS)**:
   - Configured with **1 System Node Pool (1 node)** and **1 User Node Pool (1 node)**.
   - Disconnected from ACR (`attach_acr = false`) as per design specification.

3. **Public Azure Container Registry (ACR)**:
   - Configured for public access (`public_network_access_enabled = true`).

4. **Remote State Storage**:
   - Configured via Azure Storage Account backend in `backend.tf` (`key = "<env>.terraform.tfstate"`).

5. **`terraform.tfvars` Blank Placeholders**:
   - All variable keys are declared in `terraform.tfvars` with empty string/map placeholders ready for your custom inputs.

---

## 🚀 Execution Instructions

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

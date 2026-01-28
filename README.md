# Secure Azure 3-Tier Architecture with Terraform

This project demonstrates how to design, provision, and deploy a \*\*highly secure, production-style 3‑tier architecture on Microsoft Azure using Terraform, GitHub Actions, and Managed Identity without storing secrets in code or CI/CD.

The goal of this project is to showcase real-world cloud engineering patterns:

- Defense‑in‑depth networking
- Least‑privilege access using Managed Identity
- Private connectivity using Private Endpoints
- Fully automated infrastructure and application deployment

---

## 🏗 Architecture Overview

The architecture follows a classic 3‑tier model:

1. Ingress / Web Tier
   - Azure Application Gateway
   - Linux Virtual Machine Scale sets as backend pools
   - Https traffic termination

2. Application Tier
   - Linux Virtual Machines (no public IPs)
   - System‑Assigned Managed Identity
   - Application code runs here

3. Data Tier
   - Azure SQL Database (Private Endpoint)
   - Azure Blob Storage (Private Endpoint)

All resources are deployed inside a **private Azure Virtual Network**.

---

## 🔐 Security Principles Used

- No secrets in code or CI/CD
- Managed Identity for authentication
- Azure RBAC for resource access
- SQL roles for database authorization
- Private Endpoints for data services
- Network Security Groups (NSGs) for traffic control

This ensures:

- Credentials are never exposed
- Access is scoped and auditable
- Network access alone is not sufficient to compromise data

---

🌐 Networking

- Azure Virtual Network with multiple subnets:
  - Application Gateway subnet
  - Application VM subnet
  - Private Endpoint subnet

- Network Security Groups restrict traffic between tiers
- No public access to VMs, SQL, or Storage

Private connectivity is enforced using Azure Private Endpoints and Private DNS Zones.

---

## 🧾 Identity & Access Management

### Application Identity

- Each VM uses a System‑Assigned Managed Identity
- The application authenticates using Azure AD tokens

### Azure RBAC (Terraform‑managed)

| Resource             | Role                          |
| -------------------- | ----------------------------- |
| Storage Account      | Storage Blob Data Contributor |
| (Optional) Key Vault | Key Vault Secrets User        |

### SQL Authorization (Database‑managed)

Inside Azure SQL Database:

```sql
CREATE USER [your vm name] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [your vm name];
ALTER ROLE db_datawriter ADD MEMBER [your vm name];
```

Authentication is handled by Azure AD, authorization by SQL roles.

---

## ⚙ Infrastructure as Code (Terraform)

Terraform is used to provision:

- Resource Groups
- Virtual Network & Subnets
- Network Security Groups
- Application Gateway (WAF v2)
- Virtual Machines with Managed Identity
- Azure SQL Database
- Azure Blob Storage
- Private Endpoints
- Private DNS Zones
- Azure RBAC Role Assignments

### Module Structure

```text
infra/
├── modules/
        ├── compute/
        ├── data/
        ├── iam/
        ├── network/
        ├── nsg/
        ├── storage/
        ├── general/
        ├── endpoints/
        ├── database/
├── provider.tf
├── variables.tf
└── main.tf
```

Each module exposes outputs that are consumed by other modules to keep the design clean and reusable.

---

## 🚀 CI/CD with GitHub Actions

GitHub Actions is used to fully automate deployment.

### Responsibilities

- Authenticate to Azure using OIDC
- Run Terraform (init / plan / apply)
- Assign Azure RBAC roles
- Run one‑time SQL bootstrap scripts
- Deploy application code to VM

### Identity Separation

| Phase                       | Identity Used                    |
| --------------------------- | -------------------------------- |
| Infrastructure provisioning | GitHub Actions Service Principal |
| Role assignments            | GitHub Actions Service Principal |
| Application runtime         | VM Managed Identity              |

---

## 📁 Repository Structure

```text
repo/
├── infra/          # Infrastructure as Code
├── app/                # Application source code
├── scripts/            # Deployment & bootstrap scripts
│   └── deploy.sh
├── .github/
│   └── workflows/
│       └── deploy.yml
└── README.md
```

---

## 📦 Application Deployment

- Application code is deployed to the VM using GitHub Actions
- A `deploy.sh` script installs dependencies and starts the app
- The app authenticates to Azure services using **DefaultAzureCredential**

No credentials are stored or injected at runtime.

---

## 🧪 Testing & Validation

- Verify Application Gateway health probes
- Validate private connectivity using Azure Network Watcher
- Confirm Managed Identity access to:
  - Azure Blob Storage
  - Azure SQL Database

---

## 🎯 What This Project Demonstrates

- Real‑world Azure networking and security patterns
- Secure identity‑based access without secrets
- Clean Terraform module design
- Production‑ready CI/CD workflow

This project is intentionally designed to reflect **how modern cloud platforms are built in practice**, not toy examples.

---

## 📌 Future Improvements

- Blue/green deployments
- Autoscaling VM scale sets
- Centralized logging with Azure Monitor
- Key Vault integration for non‑Azure secrets

---

## 🧠 Key Takeaway

> **Network controls who can connect, identity proves who you are, and permissions decide what you can do.**

This project applies that principle consistently across all layers.

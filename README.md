🚀 3-Tier Azure Infrastructure with Terraform

📖 Overview

This project provisions a secure, production-ready 3-tier web application infrastructure on Microsoft Azure using Terraform.

The deployment was designed to meet client requirements for scalability, security, and monitoring, ensuring that both internal and external application traffic is efficiently handled and highly available.

The solution includes:
• Web Tier – Highly available via a VM Scale Set behind a Public Load Balancer.
• Application Tier – Hosted on a VM Scale Set behind an Internal Load Balancer.
• Database Tier – Single secure VM for persistence.
• Security Layer – NSGs, subnet isolation, and Bastion host for secure access.
• Monitoring – Azure Monitor alerts for CPU, memory, disk, and availability.

🏗️ Architecture

The infrastructure follows a standard 3-tier architecture pattern.

📌 Diagram:

Internet
│
[ Public Load Balancer ]
│
Web VMSS (Scale Set)
│
[ Internal Load Balancer ]
│
App VMSS (Scale Set)
│
Database VM

Additional components:
• Azure Bastion – Secure access without exposing public SSH/RDP.
• Azure Monitor – Metrics and alerts for availability & performance.
• Terraform Remote State (Azure Storage) – State stored centrally for reliability.

⸻

⚙️ Tech Stack
• Terraform – Infrastructure as Code (IaC)
• Azure Compute – VM Scale Sets & Virtual Machines
• Azure Networking – VNet, Subnets, NSGs, Load Balancers
• Azure Bastion – Secure remote access
• Azure Monitor – Metrics & Alerts
• GitHub – App bootstrap scripts pulled directly from repo

📂 Project Structure

.
├── main.tf # Root Terraform configuration
├── variables.tf # Input variables
├── network.tf # VNet, Subnets, NSGs
├── compute.tf # VM Scale Sets & Database VM
├── security.tf # Security Rules
├── bastion.tf # Bastion configuration
├── balancer.tf # Public & Internal Load Balancers
├── monitoring.tf # Azure Monitor Alerts & Action Groups
├── backend.tf # Remote state configuration
├── outputs.tf # Key output values
├── local.tf #local variables
├── provider.tf #terraform provider for azure
├── diagram/
│ └── 3-tier.png # Infrastructure diagram
└── README.md # Documentation

🚀 Deployment Guide

1️⃣ Clone the Repository
git clone https://github.com/DaniAzure29/Azure_3_Tier_Infra.git
cd Azure-3_Tier-Infra

2️⃣ Configure Backend & Variables

Update backend.tf with your Storage Account, Container, and Resource Group.
Define environment-specific inputs in terraform.tfvars.

3️⃣ Initialize Terraform
./infra/.terraform init
or cd Azure-3_Tier-Infra/infra
.terraform init

4️⃣ Validate & Plan Deployment
.terraform plan

5️⃣ Apply Deployment
.terraform apply -auto-approve

📊 Monitoring & Scaling
• VM Scale Sets automatically scale out/in based on demand.
• Azure Monitor sends alerts when:
• CPU > 75%
• Available memory < 500MB
• Disk usage > 80%
• VM Availability drops

⸻

🔐 Security Highlights
• No public IPs on VMs (only Load Balancers & Bastion exposed).
• NSGs enforce least-privilege access.
• SSH authentication with keys (password disabled).
• Remote state stored securely in Azure Storage.

⸻

🎯 Deliverables
• A fully automated 3-tier Azure infrastructure deployment.
• Scalable Web & App tiers with load balancers.
• Secure database tier with network isolation.
• Monitoring & alerting for proactive response.
• Architecture diagram included for clarity.

⸻

👉 This project demonstrates end-to-end cloud infrastructure delivery for a client, from design (diagram) to deployment (Terraform) to monitoring (Azure Monitor).

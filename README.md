#Azure 3-Tier Infrastructure

This project provisions a 3-tier web app infrastructure on Azure using Terraform.

✅ Completed so far
Network Layer
Virtual Network (VNet) with three subnets:

Web subnet – for frontend tier

App subnet – for backend tier

DB subnet – for database tier

Network Security Groups (NSGs) created and associated with each subnet

Azure Bastion Host for secure SSH/RDP without exposing VM public IPs

Public Load Balancer for frontend tier

Internal Load Balancer for backend tier

Architecture Diagram (3-tier.png) illustrating the full layout

Compute Layer
Two Azure Virtual Machine Scale Sets (VMSS):

Frontend VMSS in the Web subnet

Uses Custom Script Extension to install Docker, pull frontend code from GitHub, build and run container

Behind a Public Load Balancer for internet traffic

Backend VMSS in the App subnet

Uses Custom Script Extension to install Docker, pull backend code from GitHub, build and run container

Behind an Internal Load Balancer for secure internal traffic only

VMSS instances are provisioned automatically with the application running at first boot — no manual setup needed

SSH access restricted via Azure Bastion

🛠 Next Steps
Database Layer — deploy Azure Database for MySQL/PostgreSQL or SQL Server in DB subnet

Monitoring & Logging — enable Azure Monitor, Log Analytics, and alerts

CI/CD — integrate with GitHub Actions or Azure DevOps for automated deployments

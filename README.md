# Azure 3-Tier Infrastructure (Network Layer)

This project is for deploying a 3-tier web app infrastructure on Azure using Terraform.

So far, the following has been completed:

- Created a virtual network (VNet)
- Created three subnets: web, app, and db
- Created and attached Network Security Groups (NSGs) to each subnet
- Created a Bastion Host
- Created public and internal load balancers
- Added an architecture diagram (`3-tier.png`) showing the full layout

More components (e.g. Bastion, compute, load balancer) will be added in future commits.

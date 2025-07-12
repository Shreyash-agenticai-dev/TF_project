# 🚀 Terraform AWS VPC Setup

This repository provides a Terraform configuration to provision a general-purpose AWS infrastructure setup. It includes networking resources such as a VPC, public/private subnets, routing, security groups, and EC2 instances with a Bastion host for secure access.

---

## 📦 Features

- **VPC**: Custom Virtual Private Cloud
- **Subnets**: Public and private subnets
- **Route Tables**: With route associations for internet access and internal routing
- **Security Groups**: Separate rules for Bastion host and internal instances
- **EC2 Instances**:
  - Bastion Host in public subnet
  - Application/target instance in private subnet
  - Access to the private instance only via Bastion (SSH Jump Host)

---
<img width="979" height="443" alt="image" src="https://github.com/user-attachments/assets/f76bfbde-299b-4bfe-9a43-ad22f26c2c64" />

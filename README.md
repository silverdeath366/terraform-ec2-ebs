# Terraform EC2 + EBS Project

This project provisions a basic AWS infrastructure using Terraform.

###  What It Creates:
- A custom VPC with a public subnet
- An internet gateway with route table for outbound internet access
- A security group allowing SSH access from a defined IP
- An EC2 instance running Ubuntu in the selected AZ
- An attached EBS volume (1GB) mounted automatically at `/mnt/data`

---

##  How to Use

1. Replace `<your-ip>/32` in the `aws_security_group_rule` with your actual public IP.

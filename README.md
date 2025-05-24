# Terraform EC2 + EBS Project

This project provisions a basic AWS infrastructure using Terraform.

What it creates: a custom VPC with a public subnet, an internet gateway with route table for outbound access, a security group allowing SSH from a defined IP, an EC2 instance running Ubuntu, and an EBS volume (1GB) mounted automatically at /mnt/data.

How to use: 1) Replace `<your-ip>/32` in the security group rule. 2) Make sure the key pair (e.g. flask-nginx-key) exists in your region. 3) In terminal run:

terraform init  
terraform apply

After apply, SSH into the EC2 and run:

df -h

You should see /mnt/data listed.

Requirements: Terraform v1.x+, AWS CLI or configured credentials, and a valid AWS key pair.

Notes: The EBS volume is formatted and mounted via user_data on boot and persists using /etc/fstab.

To push this file:

git add README.md  
git commit -m "Final simple README"  
git push

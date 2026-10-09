#!/bin/bash

#adding volume to /home folder for terraform purpose
growpart /dev/nvme0n1 4
lvextend -L +30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

#install terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

#create database server
cd /home/ec2-user
git clone https://github.com/nikitha84/terraform-with-roboshop.git
chown ec2-user:ec2-user -R terraform-with-roboshop
#chown ec2-user:ec2-user -R terraform-roboshop-component
 #becoz we r deleting aws cmd line in catalogue
cd terraform-with-roboshop/5-database
terraform init
terraform apply -auto-approve

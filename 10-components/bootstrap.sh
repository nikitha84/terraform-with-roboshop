#!/bin/bash

component=$1
environment=$2
dnf install ansible -y
#ansible-pull -U https://github.com/nikitha84/roboshop-ansible-role-tf.git -e component=$component main.yaml
# or
# git clone ansible-playbook
# cd ansible-playbook
# ansible-playbook -i inventory main.yaml
REPO_URL=https://github.com/nikitha84/roboshop-ansible-role-tf.git

REPO_DIR=/opt/roboshop/ansible
ANSIBLE_DIR=roboshop-ansible-role-tf


mkdir -p $REPO_DIR
mkdir -p /var/log/roboshop/
touch ansible.log

cd $REPO_DIR 
#check if ansible repo exist or not

if [ -d $ANSIBLE_DIR ]; then  #check if DIR already exist
    cd $ANSIBLE_DIR
    git pull
else
    git clone $REPO_URL   #if not exist pull the changes
    cd $ANSIBLE_DIR
fi    

ansible-playbook -e component=$component -e environment=$environment main.yaml


#for loop
#for i in 1-vpc/ 2-sg/ 3-bastion/ 4-sg-rules / 5-database/ 6-backend-alb/ 8-acm/ 9-frontend-alb/; do cd $i; terraform apply -auto-approve; cd .. ;done
#!/bin/bash

yum install ansible -y

cd /tmp
git clone https://github.com/nikitha84/roboshop-ansible-role-1.git

cd roboshop-ansible-role-1
ansible-playbook -e component=mongodb main.yaml
ansible-playbook -e component=redis main.yaml
ansible-playbook -e component=catalogur main.yaml
ansible-playbook -e component=user main.yaml
ansible-playbook -e component=cart main.yaml



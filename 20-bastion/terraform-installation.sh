#!/bin/bash
#increasing bastion /home folder volume for terraform purpose  
growpart /dev/nvme0n1 4
lvextend -l +100%FREE /dev/mapper/RootVG-homeVol
xfs_growfs /home

#installing terraform 
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

cd /home/ec2-user

su - ec2-user -c '
  git clone https://github.com/AnuragBojja/terraform-aws-40-databases.git
  git clone https://github.com/AnuragBojja/terraform-aws-80-service.git

  cd terraform-aws-40-databases
  terraform init
  terraform apply -auto-approve

  cd ../terraform-aws-80-service
  terraform init
  terraform apply -auto-approve
'
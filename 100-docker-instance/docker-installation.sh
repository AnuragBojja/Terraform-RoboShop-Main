#!/bin/bash
#increasing bastion /home folder volume for terraform purpose  
growpart /dev/nvme0n1 4
lvextend -l +100%FREE /dev/mapper/RootVG-homeVol
xfs_growfs /var

#installing docker
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker 
systemctl enable docker 
usermod -aG docker ec2-user

cd /home/ec2-user
su - ec2-user -c '
  git clone https://github.com/AnuragBojja/docker-files.git
'
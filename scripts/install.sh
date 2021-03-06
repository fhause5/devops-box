#!/bin/bash
set -x

if [ -e /etc/redhat-release ] ; then
  REDHAT_BASED=true
fi

TERRAFORM_VERSION="0.11.7"
PACKER_VERSION="1.2.4"
# create new ssh key
[[ ! -f /home/ubuntu/.ssh/mykey ]] \
&& mkdir -p /home/ubuntu/.ssh \
&& ssh-keygen -f /home/ubuntu/.ssh/mykey -N '' \
&& chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# install packages
if [ ${REDHAT_BASED} ] ; then
  yum -y update
  yum install -y docker ansible unzip wget nano git
else 
  apt-get update
  apt-get -y install docker.io ansible unzip nano git
fi
# add docker privileges
usermod -G docker ubuntu
# install pip
pip install -U pip && pip3 install -U pip
if [[ $? == 127 ]]; then
    wget -q https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    python3 get-pip.py
fi
# install awscli and ebcli
pip install -U awscli
pip install -U awsebcli

#terraform
T_VERSION=$(/usr/local/bin/terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}

[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# packer
P_VERSION=$(/usr/local/bin/packer -v)
P_RETVAL=$?

[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip

# OC cli and kubectl
OC="3.9.0"
KUBECTL="1.17.0"

wget https://github.com/openshift/origin/releases/download/v$OC/openshift-origin-client-tools-v$OC-191fece-linux-64bit.tar.gz
tar -xvf *.tar.gz
cd openshift-origin-client-tools*
mv oc /usr/local/bin/
cd ..

curl -LO https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/

rm -rf openshift*
rm -rf kubectl
rm -rf *.tar.gz


# Allow PasswordAuthentication 

sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config


###########################################
################# JENKINS #################
###########################################
#function jenkinsUbuntu {

#sudo apt update
#sudo apt install openjdk-8-jdk -y

#wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add - /n
#sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
#sudo apt update
#sudo apt install jenkins -y
#}
#if [ ${REDHAT_BASED} ] ; then
#  echo "Installing jenkins in centos"

#else 
#  echo "Installing jenkins in ubuntu"
  # jenkinsUbuntu
#fi

###########################################
############## just uncomment #############
###########################################
# clean up

if [ ${REDHAT_BASED} ] ; then
  service sshd restart
else 
  service ssh restart
fi

if [ ! ${REDHAT_BASED} ] ; then
  apt-get clean
fi


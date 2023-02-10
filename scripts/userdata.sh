Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]
--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"
output : { all : '| tee -a /var/log/cloud-init-output.log' }
#!/bin/bash
echo hi~ again
cd /usr/local/src
# download kubectl
curl -LO "https://dl.k8s.io/release/v1.23.0/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/v1.23.0/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
chmod +x kubectl
cp kubectl /usr/bin
echo "alias k='kubectl'" >> ~/.bashrc
echo "alias h='helm'" >> ~/.bashrc
source ~/.bashrc
# download eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin
eksctl version
# download helm
curl -LO https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz
tar xfz helm*
cp linux-amd64/helm /usr/bin
# install git
yum install git -y
# install go
wget https://go.dev/dl/go1.20.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.linux-amd64.tar.gz
cp /usr/local/go/bin/go /usr/bin
#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update package lists
apt-get update -y

# Install dependencies
apt-get install -y curl unzip

# Install kubectl
KUBECTL_VERSION="1.30.4"
KUBECTL_DATE="2024-09-11"
KUBECTL_URL="https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/${KUBECTL_DATE}/bin/linux/amd64/kubectl"
KUBECTL_SHA_URL="${KUBECTL_URL}.sha256"

curl -O "$KUBECTL_URL"
curl -O "$KUBECTL_SHA_URL"
sha256sum -c kubectl.sha256
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl
export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

# Verify kubectl installation
kubectl version --client

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Verify eksctl installation
eksctl version

# Reload shell configuration
source ~/.bashrc

echo "Installation completed successfully."

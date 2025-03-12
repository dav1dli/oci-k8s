#!/bin/bash
# Get token from master node
TOKEN=$(ssh opc@${master_ip} 'cat /home/opc/node-token')

# Install k3s on worker node
curl -sfL https://get.k3s.io | K3S_URL=https://${master_ip}:6443 K3S_TOKEN=$TOKEN sh -

# Set up firewall rules
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --reload

# Install OCI CLI for vault integration
sudo yum install -y python36-oci-cli

# Create config for OCI Vault integration
mkdir -p /home/opc/.oci
cat << EOF > /home/opc/.oci/config
[DEFAULT]
use_instance_principal = true
EOF
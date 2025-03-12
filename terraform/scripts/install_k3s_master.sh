#!/bin/bash
# Install k3s on master node
curl -sfL https://get.k3s.io | sh -

# Get the token for worker nodes to join
sudo cat /var/lib/rancher/k3s/server/node-token > /home/opc/node-token

# Set up firewall rules
sudo firewall-cmd --permanent --add-port=6443/tcp
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
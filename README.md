# oci-k8s
Kubernetes in Oracle Cloud Infeastructure

```
                      ┌───────────────┐
                      │  Public Load  │
                      │   Balancer    │
                      └───────┬───────┘
                              │
                              ▼
┌──────────────┐     ┌───────────────┐     ┌───────────────┐
│    Bastion   │     │      K8s on   │     │  OCI Vault    │
│    Service   │────▶│  Compute VMs  │◀────│  (Secrets)    │
└──────────────┘     └───────────────┘     └───────────────┘
                              │
                              ▼
                      ┌───────────────┐
                      │ Logging and   │
                      │  Monitoring   │
                      └───────────────┘
```
# Networking
* VCN with private and public subnets
* Security Lists for traffic control
* External access is configured using load balancer
* Remote control is provided using OCI Bastion

# Kubernetes
Container Engine for Kubernetes (OKE) is not in Always Free tier. Build k8s cluster manually / with scripts using K3s.

Use ARM OCPUs to build k8s cluster. Benefits:
* More CPU cores: 4 OCPUs total vs. 0.25 OCPU with AMD
* More memory: 24 GB total vs. 2 GB with AMD
* Better performance per watt: ARM architecture is more efficient
* Same Always Free eligibility: No additional costs

# Secrets
Secrets are managed in OCI Vault. Use OCI Instance Principle for authentication.

# Logging and Monitoring
Use OCI Logging and Monitoring services

# Restrictions
* LB is limited to 10Mbps bandwidth
* Only one LB in free tier

# Setup
Setup OCI credentials: `oci setup config`

Update the configuration with tenancy, user OCIDs, and fingerprint from OCI console.

Generate SSH keys for VM access.

Find Linux image: `oci compute image list --compartment-id <compartment_ocid> --operating-system "Oracle Linux"`

Run terraform:
```
terraform init
terraform plan
terraform apply
```

Post-setup:
* Set up kubectl
* Install ingress controller (NGINX)
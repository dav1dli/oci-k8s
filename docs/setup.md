# Setup
It is not neccessary to setup local oci cli - there is Oracle Cloud Shell in Console which is already set up. It runs on Oracle Linux 8. 
It provides 5GB storage and preinstalled with tools like kubectl, helm, terraform.

## Pre-configure
In OCI Web go to Profile -> User: copy OCID. In tenancy: copy tenancy OCID.

Add API key:
* Only RSA key is supported. generate: `ssh-keygen -t rsa`
* User -> API keys -> Add API key -> Generate PEM key pair. Download private key, place it in home directory.
* Configure `.oci/config`:
```
[DEFAULT]
user=ocid1.user.oc1.***
fingerprint=83:c4:65***
tenancy=ocid1.tenancy.oc1.***
region=uk-london-1
key_file=/Users/USER/.ssh/oci.pem
```
* fix permissions: `chmod 600 .oci/config`
## Local setup: Mac OS
* Install on Mac OS: `bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"`
* Setup OCI credentials: `oci setup config` - unnecessary, as it was already setup manually in pre-configure

## Initialize TF backend bucket
OCI provider can be configured to manage the state in a remote storage but it is provided as AWS S3 compatible storage and requires configuring as such.

Set settings:
```
export TENANCY_OCID=$(grep tenancy ~/.oci/config | awk -F'=' '{print $2}' | tr -d ' ')
export REGION=$(oci iam region-subscription list --query "data[0].\"region-name\"" --raw-output)
export NAMESPACE=$(oci os ns get --query "data" --raw-output)
```

Create compartment:
```
DEV_COMPARTMENT_ID=$(oci iam compartment create \
  --compartment-id $TENANCY_OCID \
  --name "dev" \
  --description "Compartment for development resources" \
  --query "data.id" \
  --raw-output)
```
Create storage bucket:
```
oci os bucket create \
  --compartment-id $TENANCY_OCID \
  --name "terraform-state" \
  --namespace $NAMESPACE \
  --versioning Enabled
```
Configure authentication:
* Generate secret key pair: Profile picture -> My profile -> Customer secret keys -> Generate secret key: name: default; copy secret key (it won't be shown again)
* Create ˜/.aws/credentials file:
```
[default]
aws_access_key_id=15c47***
aws_secret_access_key=24sZOD****
```
Configure `backend.tfvars` file with backend parameters. Configure `oci` provider to use the backend. In `init` use `-backend-config` option.

## Environment
Set environment variables:
```
export TF_VAR_tenancy_ocid=$TENANCY_OCID
export TF_VAR_region=$REGION
export TF_VAR_namespace=$NAMESPACE
export TF_VAR_dev_compartment_id=$DEV_COMPARTMENT_ID
```
Generate SSH keys for VM access.

Find Linux image: `oci compute image list --compartment-id <compartment_ocid> --operating-system "Oracle Linux"`

## Run terraform
```
terraform init -var-file=./config/uk-south/terraform.tfvars -backend-config=./config/uk-south/backend.tfvars
terraform plan -var-file=./config/uk-south/terraform.tfvars -out infra.tfplan
terraform apply infra.tfplan
```
Note: currently does not work. Manage the state manually:
```
export LANG="en_US.UTF-8"
oci os object get --bucket-name terraform-state --file terraform.tfstate --name dev/terraform.tfstate --namespace lrkgdkwsw4ux
terraform init -var-file=./config/uk-south/terraform.tfvars 
terraform plan -var-file=./config/uk-south/terraform.tfvars -out infra.tfplan
terraform apply infra.tfplan
oci os object put --bucket-name terraform-state --file terraform.tfstate --name dev/terraform.tfstate --namespace lrkgdkwsw4ux
```

Post-setup:
* Set up kubectl
* Install ingress controller (NGINX)


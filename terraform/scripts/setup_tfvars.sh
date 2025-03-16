#!/bin/bash
TENANCY_OCID=$(grep tenancy ~/.oci/config | awk -F'=' '{print $2}' | tr -d ' ')
REGION=$(oci iam region-subscription list --query "data[0].\"region-name\"" --raw-output)
NAMESPACE=$(oci os ns get --query "data" --raw-output)

echo "Found the following OCI configuration values:"
echo "Tenancy OCID: $TENANCY_OCID"
echo "Region: $REGION"
echo "Namespace: $NAMESPACE"

cat > terraform.tfvars << EOT
tenancy_ocid = "$TENANCY_OCID"
region = "$REGION"
namespace = "$NAMESPACE"
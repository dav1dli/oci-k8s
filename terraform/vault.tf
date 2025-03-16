# OCI Vault for secrets
resource "oci_kms_vault" "k8s_vault" {
  compartment_id = data.oci_identity_compartment.compartment.id
  display_name   = "k8s-vault"
  vault_type     = "DEFAULT" # Free tier eligible
}

resource "oci_kms_key" "k8s_key" {
  compartment_id = data.oci_identity_compartment.compartment.id
  display_name   = "k8s-key"
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  management_endpoint = oci_kms_vault.k8s_vault.management_endpoint
  protection_mode     = "SOFTWARE"
}
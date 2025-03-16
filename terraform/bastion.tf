# Bastion Service
resource "oci_bastion_bastion" "k8s_bastion" {
  bastion_type     = "STANDARD"
  compartment_id   = data.oci_identity_compartment.compartment.id
  target_subnet_id = oci_core_subnet.private_subnet.id
  
  client_cidr_block_allow_list = ["0.0.0.0/0"] # Restrict this
  name                         = "bastion"
}
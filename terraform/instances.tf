resource "oci_core_instance" "k8s_master" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = "k8s-master"
  
  # Using ARM shape - Free Tier eligible
  shape = "VM.Standard.A1.Flex"
  
  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }

  source_details {
    source_type = "image"
    source_id   = var.arm_image_id # Oracle Linux for ARM
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private_subnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("${path.module}/scripts/install_k3s_master.sh", {}))
  }
}

resource "oci_core_instance" "k8s_worker" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = "k8s-worker"
  
  # Using ARM shape - Free Tier eligible
  shape = "VM.Standard.A1.Flex"
  
  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  source_details {
    source_type = "image"
    source_id   = var.arm_image_id # Oracle Linux for ARM
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private_subnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("${path.module}/scripts/install_k3s_worker.sh", {
      master_ip = oci_core_instance.k8s_master.private_ip
    }))
  }

  depends_on = [oci_core_instance.k8s_master]
}

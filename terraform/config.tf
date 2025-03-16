terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
  # backend "s3" {}
}
provider "oci" {
  config_file_profile = "DEFAULT"
  region              = var.region
}
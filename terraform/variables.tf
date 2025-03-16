variable "tenancy_ocid" {
  description = "The OCID of your tenancy"
  type        = string
}

variable "user_ocid" {
  description = "The OCID of the user"
  type        = string
}

variable "region" {
  description = "The OCI region"
  type        = string
}

variable "namespace" {
  description = "The Object Storage namespace for your tenancy"
  type        = string
}

variable "compartment_id" {
  description = "The OCID of the development compartment"
  type        = string
}

variable "availability_domain" {
  description = "Availability domain"
  type        = string
  default     = "rnbA:UK-LONDON-1-AD-1"
  # oci iam availability-domain list --compartment-id  "ocid1.compartment.oc1..aaaaaaaabhlgg22coxssgqpi5qovmreocsfm27h6qhv2dknj5i4m4ysp4pwq"
}

variable "arm_image_id" {
  description = "OCID of the Oracle Linux ARM image"
  type        = string
  default     = "ocid1.image.oc1.uk-london-1.aaaaaaaalbvf7rzb44dev3axp5pq5xcbcyylwgu2frfrfgdxvieacor2h36q"
  # Find ARM images with: 
  # oci compute image list --compartment-id "ocid1.compartment.oc1..aaaaaaaabhlgg22coxssgqpi5qovmreocsfm27h6qhv2dknj5i4m4ysp4pwq" --operating-system "Oracle Linux" --shape "VM.Standard.A1.Flex" --operating-system-version "8"
}
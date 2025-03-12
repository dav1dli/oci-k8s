resource "oci_core_vcn" "k8s_vcn" {
  compartment_id = var.compartment_id
  cidr_block     = "10.0.0.0/16"
  display_name   = "k8s-vcn"
  dns_label      = "k8svcn"
}

# Public subnet for load balancer
resource "oci_core_subnet" "public_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.k8s_vcn.id
  cidr_block        = "10.0.0.0/24"
  display_name      = "public-subnet"
  dns_label         = "public"
  security_list_ids = [oci_core_security_list.public_security_list.id]
  route_table_id    = oci_core_route_table.public_route_table.id
}

# Private subnet for Kubernetes nodes
resource "oci_core_subnet" "private_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.k8s_vcn.id
  cidr_block                 = "10.0.1.0/24"
  display_name               = "private-subnet"
  dns_label                  = "private"
  prohibit_public_ip_on_vnic = true
  security_list_ids          = [oci_core_security_list.private_security_list.id]
  route_table_id             = oci_core_route_table.private_route_table.id
}

# Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "internet-gateway"
}

# NAT Gateway for private subnet
resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "nat-gateway"
}

# Route table for public subnet
resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "public-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

# Route table for private subnet
resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "private-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}

# Security lists
resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "public-security-list"

  # Allow HTTP/HTTPS from anywhere
  ingress_security_rules {
    protocol  = "6" # TCP
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol  = "6" # TCP
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 443
      max = 443
    }
  }

  # Allow all outbound traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }
}

resource "oci_core_security_list" "private_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.k8s_vcn.id
  display_name   = "private-security-list"

  # Allow all traffic within the VCN
  ingress_security_rules {
    protocol  = "all"
    source    = oci_core_vcn.k8s_vcn.cidr_block
    stateless = false
  }

  # Allow all outbound traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }
}
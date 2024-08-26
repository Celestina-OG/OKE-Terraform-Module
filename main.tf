provider "oci" {}

resource "oci_core_vcn" "this" {
  cidr_block       = var.cidr_block
  compartment_id   = var.compartment_id
  display_name     = var.vcn_display_name
  dns_label        = var.vcn_dns_label
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id
  display_name   = var.igw_display_name
  enabled        = true
  vcn_id         = oci_core_vcn.this.id
}

resource "oci_core_nat_gateway" "this" {
  compartment_id = var.compartment_id
  display_name   = var.ngw_display_name
  vcn_id         = oci_core_vcn.this.id
}

resource "oci_core_service_gateway" "this" {
  compartment_id = var.compartment_id
  display_name   = var.sgw_display_name
  services {
    service_id = var.service_id
  }
  vcn_id = oci_core_vcn.this.id
}

resource "oci_core_route_table" "this" {
  compartment_id = var.compartment_id
  display_name   = var.private_route_table_display_name

  route_rules {
    description         = "traffic to the internet"
    destination         = "0.0.0.0/0"
    destination_type    = "CIDR_BLOCK"
    network_entity_id   = oci_core_nat_gateway.this.id
  }

  route_rules {
    description         = "traffic to OCI services"
    destination         = "all-lhr-services-in-oracle-services-network"
    destination_type    = "SERVICE_CIDR_BLOCK"
    network_entity_id   = oci_core_service_gateway.this.id
  }

  vcn_id = oci_core_vcn.this.id
}

resource "oci_core_subnet" "service_lb_subnet" {
  cidr_block                 = var.service_lb_subnet_cidr
  compartment_id             = var.compartment_id
  display_name               = var.service_lb_subnet_display_name
  dns_label                  = var.service_lb_subnet_dns_label
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_default_route_table.this.id
  security_list_ids          = [oci_core_vcn.this.default_security_list_id]
  vcn_id                     = oci_core_vcn.this.id
}

resource "oci_core_subnet" "node_subnet" {
  cidr_block                 = var.node_subnet_cidr
  compartment_id             = var.compartment_id
  display_name               = var.node_subnet_display_name
  dns_label                  = var.node_subnet_dns_label
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.this.id
  security_list_ids          = [oci_core_security_list.node_sec_list.id]
  vcn_id                     = oci_core_vcn.this.id
}

resource "oci_core_subnet" "kubernetes_api_endpoint_subnet" {
  cidr_block                 = var.kubernetes_api_endpoint_subnet_cidr
  compartment_id             = var.compartment_id
  display_name               = var.kubernetes_api_endpoint_subnet_display_name
  dns_label                  = var.kubernetes_api_endpoint_subnet_dns_label
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_default_route_table.this.id
  security_list_ids          = [oci_core_security_list.kubernetes_api_endpoint_sec_list.id]
  vcn_id                     = oci_core_vcn.this.id
}

resource "oci_core_default_route_table" "this" {
  display_name = var.public_route_table_display_name

  route_rules {
    description         = "traffic to/from internet"
    destination         = "0.0.0.0/0"
    destination_type    = "CIDR_BLOCK"
    network_entity_id   = oci_core_internet_gateway.this.id
  }

  manage_default_resource_id = oci_core_vcn.this.default_route_table_id
}

resource "oci_core_security_list" "service_lb_sec_list" {
  compartment_id = var.compartment_id
  display_name   = var.service_lb_sec_list_display_name
  vcn_id         = oci_core_vcn.this.id
}

resource "oci_core_security_list" "node_sec_list" {
  compartment_id = var.compartment_id
  display_name   = var.node_sec_list_display_name

  egress_security_rules {
    description         = "Allow pods on one worker node to communicate with pods on other worker nodes"
    destination         = var.node_subnet_cidr
    destination_type    = "CIDR_BLOCK"
    protocol            = "all"
    stateless           = false
  }

  egress_security_rules {
    description         = "Access to Kubernetes API Endpoint"
    destination         = var.kubernetes_api_endpoint_subnet_cidr
    destination_type    = "CIDR_BLOCK"
    protocol            = "6"
    stateless           = false
  }

  # Other egress and ingress rules...

  vcn_id = oci_core_vcn.this.id
}

resource "oci_core_security_list" "kubernetes_api_endpoint_sec_list" {
  compartment_id = var.compartment_id
  display_name   = var.kubernetes_api_endpoint_sec_list_display_name

  egress_security_rules {
    description         = "Allow Kubernetes Control Plane to communicate with bancom"
    destination         = "all-lhr-services-in-oracle-services-network"
    destination_type    = "SERVICE_CIDR_BLOCK"
    protocol            = "6"
    stateless           = false
  }

  # Other egress and ingress rules...

  vcn_id = oci_core_vcn.this.id
}

resource "oci_containerengine_cluster" "this" {
  cluster_pod_network_options {
    cni_type = "OCI_VCN_IP_NATIVE"
  }
  compartment_id = var.compartment_id
  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.kubernetes_api_endpoint_subnet.id
  }
  freeform_tags = {
    "OKEclusterName" = var.cluster_name
  }
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name

  options {
    admission_controller_options {
      is_pod_security_policy_enabled = false
    }
    persistent_volume_config {
      freeform_tags = {
        "OKEclusterName" = var.cluster_name
      }
    }
    service_lb_config {
      freeform_tags = {
        "OKEclusterName" = var.cluster_name
      }
    }
    service_lb_subnet_ids = [oci_core_subnet.service_lb_subnet.id]
  }
  type   = "ENHANCED_CLUSTER"
  vcn_id = oci_core_vcn.this.id
}

resource "oci_containerengine_node_pool" "this" {
  cluster_id      = oci_containerengine_cluster.this.id
  compartment_id  = var.compartment_id
  freeform_tags   = {
    "OKEnodePoolName" = var.node_pool_name
  }
  kubernetes_version = var.kubernetes_version
  name               = var.node_pool_name

  node_config_details {
    node_pool_pod_network_option_details {
      cni_type = "OCI_VCN_IP_NATIVE"
    }
    placement_configs {
      availability_domain = var.availability_domain_1
      subnet_id           = oci_core_subnet.node_subnet.id
    }
    placement_configs {
      availability_domain = var.availability_domain_2
      subnet_id           = oci_core_subnet.node_subnet.id
    }
    placement_configs {
      availability_domain = var.availability_domain_3
      subnet_id           = oci_core_subnet.node_subnet.id
    }
    size = var.node_pool_size
  }

  node_eviction_node_pool_settings {
    eviction_grace_duration = var.eviction_grace_duration
  }
  node_shape        = var.node_shape
  node_shape_config {
    memory_in_gbs = var.memory_in_gbs
    ocpus         = var.ocpus
  }
  node_source_details {
    image_id    = var.image_id
    source_type = "IMAGE"
  }
}

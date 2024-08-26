# OCI Cluster Module

This module creates an Oracle Cloud Infrastructure (OCI) Kubernetes Cluster with necessary networking resources like VCN, Subnets, Gateways, Security Lists, etc.

## Usage

```hcl
module "oci_cluster" {
  source = "path_to_module"

  compartment_id        = "ocid1.compartment.oc1..example"
  cidr_block            = "10.0.0.0/16"
  vcn_display_name      = "my-vcn"
  vcn_dns_label         = "myvcn"
  igw_display_name      = "my-igw"
  ngw_display_name      = "my-ngw"
  sgw_display_name      = "my-sgw"
  service_id            = "ocid1.service.oc1..example"
  public_route_table_display_name = "public-rt"
  private_route_table_display_name = "private-rt"
  service_lb_subnet_cidr = "10.0.1.0/24"
  service_lb_subnet_display_name = "service-lb-subnet"
  service_lb_subnet_dns_label = "slbsubnet"
  node_subnet_cidr      = "10.0.2.0/24"
  node_subnet_display_name = "node-subnet"
  node_subnet_dns_label = "nodesubnet"
  kubernetes_api_endpoint_subnet_cidr = "10.0.3.0/24"
  kubernetes_api_endpoint_subnet_display_name = "k8s-api-subnet"
  kubernetes_api_endpoint_subnet_dns_label = "k8sapinet"
  service_lb_sec_list_display_name = "slbsec"
  node_sec_list_display_name = "nodesec"
  kubernetes_api_endpoint_sec_list_display_name = "k8sapilist"
  cluster_name          = "my-cluster"
  kubernetes_version    = "v1.23.5"
  node_pool_name        = "my-nodepool"
  availability_domain_1 = "ocid1.availabilitydomain.oc1..example1"
  availability_domain_2 = "ocid1.availabilitydomain.oc1..example2"
  availability_domain_3 = "ocid1.availabilitydomain.oc1..example3"
  node_pool_size        = 3
  eviction_grace_duration = "15m"
  node_shape            = "VM.Standard2.1"
  memory_in_gbs         = 16
  ocpus                 = 2
  image_id              = "ocid1.image.oc1..example"
}

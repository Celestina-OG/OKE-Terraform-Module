output "vcn_id" {
  description = "The OCID of the VCN."
  value       = oci_core_vcn.this.id
}

output "subnet_ids" {
  description = "The IDs of the subnets."
  value       = {
    service_lb_subnet             = oci_core_subnet.service_lb_subnet.id
    node_subnet                   = oci_core_subnet.node_subnet.id
    kubernetes_api_endpoint_subnet = oci_core_subnet.kubernetes_api_endpoint_subnet.id
  }
}

output "cluster_id" {
  description = "The OCID of the Kubernetes cluster."
  value       = oci_containerengine_cluster.this.id
}

output "node_pool_id" {
  description = "The OCID of the node pool."
  value       = oci_containerengine_node_pool.this.id
}

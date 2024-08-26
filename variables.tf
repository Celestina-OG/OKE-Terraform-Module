variable "compartment_id" {
  description = "The OCID of the compartment."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VCN."
  type        = string
}

variable "vcn_display_name" {
  description = "The display name of the VCN."
  type        = string
}

variable "vcn_dns_label" {
  description = "The DNS label for the VCN."
  type        = string
}

variable "igw_display_name" {
  description = "The display name of the Internet Gateway."
  type        = string
}

variable "ngw_display_name" {
  description = "The display name of the NAT Gateway."
  type        = string
}

variable "sgw_display_name" {
  description = "The display name of the Service Gateway."
  type        = string
}

variable "service_id" {
  description = "The OCID of the service to be enabled for the Service Gateway."
  type        = string
}

variable "public_route_table_display_name" {
  description = "The display name of the public route table."
  type        = string
}

variable "private_route_table_display_name" {
  description = "The display name of the private route table."
  type        = string
}

variable "service_lb_subnet_cidr" {
  description = "The CIDR block for the Service LB subnet."
  type        = string
}

variable "service_lb_subnet_display_name" {
  description = "The display name of the Service LB subnet."
  type        = string
}

variable "service_lb_subnet_dns_label" {
  description = "The DNS label for the Service LB subnet."
  type        = string
}

variable "node_subnet_cidr" {
  description = "The CIDR block for the node subnet."
  type        = string
}

variable "node_subnet_display_name" {
  description = "The display name of the node subnet."
  type        = string
}

variable "node_subnet_dns_label" {
  description = "The DNS label for the node subnet."
  type        = string
}

variable "kubernetes_api_endpoint_subnet_cidr" {
  description = "The CIDR block for the Kubernetes API Endpoint subnet."
  type        = string
}

variable "kubernetes_api_endpoint_subnet_display_name" {
  description = "The display name of the Kubernetes API Endpoint subnet."
  type        = string
}

variable "kubernetes_api_endpoint_subnet_dns_label" {
  description = "The DNS label for the Kubernetes API Endpoint subnet."
  type        = string
}

variable "service_lb_sec_list_display_name" {
  description = "The display name of the Service LB security list."
  type        = string
}

variable "node_sec_list_display_name" {
  description = "The display name of the Node security list."
  type        = string
}

variable "kubernetes_api_endpoint_sec_list_display_name" {
  description = "The display name of the Kubernetes API Endpoint security list."
  type        = string
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version."
  type        = string
}

variable "node_pool_name" {
  description = "The name of the node pool."
  type        = string
}

variable "availability_domain_1" {
  description = "The first availability domain."
  type        = string
}

variable "availability_domain_2" {
  description = "The second availability domain."
  type        = string
}

variable "availability_domain_3" {
  description = "The third availability domain."
  type        = string
}

variable "node_pool_size" {
  description = "The number of nodes in the pool."
  type        = number
}

variable "eviction_grace_duration" {
  description = "The grace duration for node eviction."
  type        = string
}

variable "node_shape" {
  description = "The shape of the node."
  type        = string
}

variable "memory_in_gbs" {
  description = "The amount of memory in GBs for the node."
  type        = number
}

variable "ocpus" {
  description = "The number of OCPUs for the node."
  type        = number
}

variable "image_id" {
  description = "The OCID of the image used for the node."
  type        = string
}

output "this_data_availability_zone" {
  value = local.zone_id
}

// Output VPC
output "vpc_id" {
  description = "The ID of the VPC."
  value       = alicloud_cs_managed_kubernetes.k8s.vpc_id
}

output "vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = alicloud_cs_managed_kubernetes.k8s.vswitch_ids
}

output "nat_gateway_id" {
  value = data.alicloud_nat_gateways.this.gateways.0.id
}

// Output kubernetes resource
output "cluster_id" {
  description = "ID of the kunernetes cluster."
  value       = alicloud_cs_managed_kubernetes.k8s.id
}

output "security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = alicloud_cs_managed_kubernetes.k8s.security_group_id
}

output "cluster_nodes" {
  description = "List nodes of cluster."
  value       = alicloud_cs_managed_kubernetes.k8s.worker_nodes
}
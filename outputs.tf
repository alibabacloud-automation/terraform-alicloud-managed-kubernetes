// Output kubernetes resource
output "this_k8s_name" {
  description = "Name of the kunernetes cluster."
  value       = alicloud_cs_managed_kubernetes.this.0.id
}
output "this_k8s_id" {
  description = "ID of the kunernetes cluster."
  value       = alicloud_cs_managed_kubernetes.this.0.id
}
output "this_k8s_nodes" {
  description = "List nodes of cluster."
  value       = alicloud_cs_managed_kubernetes.this.0.worker_nodes
}
// Output VPC
output "this_vpc_id" {
  description = "The ID of the VPC."
  value       = alicloud_cs_managed_kubernetes.this.0.vpc_id
}

output "this_vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = local.vswitch_ids
}
output "this_security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = alicloud_cs_managed_kubernetes.this.0.security_group_id
}

//Output SLS
output "this_sls_project_name" {
  description = "The sls project name used to configure cluster."
  value       = local.sls_project
}
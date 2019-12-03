// Output kubernetes resource
output "this_k8s_name" {
  description = "Name of the kunernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.name, [""])[0]
}
output "this_k8s_id" {
  description = "ID of the kunernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.id, [""])[0]
}
output "this_k8s_nodes" {
  description = "List nodes of cluster."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.worker_nodes, [""])[0]
}
// Output VPC
output "this_vpc_id" {
  description = "The ID of the VPC."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.vpc_id, [""])[0]
}

output "this_vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = local.vswitch_ids
}
output "this_security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.security_group_id, [""])[0]
}

//Output SLS
output "this_sls_project_name" {
  description = "The sls project name used to configure cluster."
  value       = local.sls_project
}
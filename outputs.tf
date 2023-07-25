// Output kubernetes resource
output "this_k8s_name" {
  description = "Name of the kunernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.name, [""])[0]
}
output "this_k8s_id" {
  description = "ID of the kunernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.id, [""])[0]
}

output "this_k8s_node_pool_id" {
  description = "ID of the kunernetes node pool."
  value       = concat(alicloud_cs_kubernetes_node_pool.this.*.id, [""])[0]
}
// Output VPC
output "this_vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = local.vswitch_ids
}
output "this_security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.security_group_id, [""])[0]
}

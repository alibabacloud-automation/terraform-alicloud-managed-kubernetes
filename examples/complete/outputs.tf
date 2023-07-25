// Output kubernetes resource
output "this_k8s_name" {
  description = "Name of the kunernetes cluster."
  value       = module.managed-k8s.this_k8s_name
}
output "this_k8s_id" {
  description = "ID of the kunernetes cluster."
  value       = module.managed-k8s.this_k8s_id
}

output "this_k8s_node_pool_id" {
  description = "ID of the kunernetes node pool."
  value       = module.managed-k8s.this_k8s_node_pool_id
}

output "this_vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = module.managed-k8s.this_vswitch_ids
}
output "this_security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = module.managed-k8s.this_security_group_id
}


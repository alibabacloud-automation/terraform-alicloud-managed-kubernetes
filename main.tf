resource "alicloud_cs_managed_kubernetes" "this" {
  count                = length(local.vswitch_ids) > 0 ? 1 : 0
  name                 = local.k8s_name
  cluster_spec         = var.cluster_spec
  worker_vswitch_ids   = local.vswitch_ids
  new_nat_gateway      = var.new_vpc == true ? false : var.new_nat_gateway
  pod_cidr             = var.k8s_pod_cidr
  service_cidr         = var.k8s_service_cidr
  slb_internet_enabled = true
  version              = var.kubernetes_version
  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }
  client_cert     = var.client_cert_path
  client_key      = var.client_key_path
  cluster_ca_cert = var.cluster_ca_cert_path
}

resource "alicloud_cs_kubernetes_node_pool" "this" {
  count                = length(local.vswitch_ids) > 0 ? 1 : 0
  name                 = local.k8s_name
  cluster_id           = alicloud_cs_managed_kubernetes.this.0.id
  vswitch_ids          = local.vswitch_ids
  instance_types       = var.worker_instance_types
  system_disk_category = var.worker_disk_category
  system_disk_size     = var.worker_disk_size
  desired_size         = var.worker_number
}
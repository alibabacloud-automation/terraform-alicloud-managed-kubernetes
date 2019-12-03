// Provider specific configs
provider "alicloud" {
  version                 = ">=1.57.2"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/managed-kubernetes"
}

resource "alicloud_log_project" "new" {
  count = var.new_sls_project == true ? 1 : 0
  // sls project name must end with lower letter
  name        = format("%s-end", substr("for-${local.k8s_name}", 0, 59))
  description = "created by terraform for managedkubernetes cluster"
}

resource "alicloud_cs_managed_kubernetes" "this" {
  count                 = length(local.vswitch_ids) > 0 ? 1 : 0
  name                  = local.k8s_name
  vswitch_ids           = local.vswitch_ids
  new_nat_gateway       = var.new_vpc == true ? false : var.new_nat_gateway
  worker_disk_category  = var.worker_disk_category
  password              = var.ecs_password
  pod_cidr              = var.k8s_pod_cidr
  service_cidr          = var.k8s_service_cidr
  slb_internet_enabled  = true
  install_cloud_monitor = true
  cluster_network_type  = var.cluster_network_type
  worker_instance_types = var.worker_instance_types
  worker_number         = var.worker_number
  log_config {
    type    = "SLS"
    project = local.sls_project == "" ? null : local.sls_project
  }
  depends_on = [alicloud_snat_entry.new]
}
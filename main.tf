// Provider specific configs
provider "alicloud" {
  version                 = ">=1.60.0"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/kubernetes"
}

resource "alicloud_log_project" "log" {
  count       = var.create_log_project ? 1 : 0
  name        = var.k8s_name_prefix == "" ? var.example_name : var.k8s_name_prefix
  description = "created by terraform for managedkubernetes cluster"
}


resource "alicloud_cs_managed_kubernetes" "k8s" {
  name                  = var.k8s_name_prefix == "" ? var.example_name : var.k8s_name_prefix
  vswitch_ids           = local.vswitch_ids
  new_nat_gateway       = var.new_nat_gateway
  worker_disk_category  = var.worker_disk_category
  worker_disk_size      = var.worker_disk_size
  password              = var.ecs_password
  pod_cidr              = var.k8s_pod_cidr
  service_cidr          = var.k8s_service_cidr
  slb_internet_enabled  = true
  install_cloud_monitor = true
  cluster_network_type  = var.cluster_network_type
  worker_instance_types = length(var.worker_instance_types) == 0 ? [data.alicloud_instance_types.this.instance_types[0].id] : var.worker_instance_types
  worker_number         = var.worker_number

  dynamic "log_config" {
    for_each = var.log_config
    content {
      type    = var.create_log_project ? "SLS" : lookup(log_config.value, "type", null)
      project = var.create_log_project ? alicloud_log_project.log.0.name : lookup(log_config.value, "project", null)
    }
  }
}
// Provider specific configs
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/managed-kubernetes"
}

resource "alicloud_cs_managed_kubernetes" "this" {
  count                 = length(local.vswitch_ids) > 0 ? 1 : 0
  name                  = local.k8s_name
  worker_vswitch_ids    = local.vswitch_ids
  new_nat_gateway       = var.new_vpc == true ? false : var.new_nat_gateway
  worker_disk_category  = var.worker_disk_category
  password              = var.ecs_password
  pod_cidr              = var.k8s_pod_cidr
  service_cidr          = var.k8s_service_cidr
  slb_internet_enabled  = true
  install_cloud_monitor = true
  version               = var.kubernetes_version
  runtime               = var.runtime
  worker_instance_types = var.worker_instance_types
  worker_number         = var.worker_number
  
  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }

  kube_config     = var.kube_config_path
  client_cert     = var.client_cert_path
  client_key      = var.client_key_path
  cluster_ca_cert = var.cluster_ca_cert_path

  enable_ssh = var.enable_ssh


  dynamic "maintenance_window" {
    for_each = var.maintenance_window.enabled ? [1]: []

    content {
      enable            = maintenance_window.value.enabled
      maintenance_time  = maintenance_window.value.maintenance_time
      duration          = maintenance_window.value.duration
      weekly_period     = maintenance_window.value.weekly_period
    }
  }

  tags = var.tags

  depends_on = [alicloud_snat_entry.new]
}

resource "alicloud_cs_kubernetes_node_pool" "autoscaling" {
  for_each = var.node_pools

  name                 = each.value.name
  cluster_id           = alicloud_cs_managed_kubernetes.this[0].id
  vswitch_ids          = local.vswitch_ids
  instance_types       = each.value.node_instance_types
  system_disk_category = "cloud_efficiency"
  system_disk_size     = each.value.system_disk_size
  node_count           = each.value.node_count

  scaling_config {
    min_size                 = each.value.node_min_number
    max_size                 = each.value.node_max_number
    is_bond_eip              = each.value.node_bind_eip
    eip_internet_charge_type = "PayByTraffic"
    eip_bandwidth            = 5
  }

  management {
    auto_repair     = each.value.auto_repair
    auto_upgrade    = each.value.auto_upgrade
    surge           = each.value.surge
    max_unavailable = each.value.max_unavailable
  }

  # spot config
  # spot_strategy = "SpotWithPriceLimit"
  # spot_price_limit {
  #   instance_type = data.alicloud_instance_types.default.instance_types.0.id
  #   # Different instance types have different price caps
  #   price_limit = "0.70"
  # }

  tags = merge(
    {
      Type = "autoscaling"
    },
    var.tags,
  )
}
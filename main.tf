// Provider specific configs
provider "alicloud" {
  version              = ">=1.57.2"
  region               = var.region != "" ? var.region : null
  configuration_source = "terraform-alicloud-modules/kubernetes"
}

// Instance_types data source for instance_type
data "alicloud_instance_types" "default" {
  cpu_core_count = var.cpu_core_count
  memory_size    = var.memory_size
}

// Zones data source for availability_zone
data "alicloud_zones" "default" {
  available_instance_type = data.alicloud_instance_types.default.instance_types[0].id
}

// If there is not specifying vpc_id, the module will launch a new vpc
resource "alicloud_vpc" "vpc" {
  count      = var.vpc_id == "" ? 1 : 0
  cidr_block = var.vpc_cidr
  name       = var.vpc_name == "" ? var.example_name : var.vpc_name
}

// According to the vswitch cidr blocks to launch several vswitches
resource "alicloud_vswitch" "vswitches" {
  count             = length(var.vswitch_ids) > 0 ? 0 : length(var.vswitch_cidrs)
  vpc_id            = var.vpc_id == "" ? join("", alicloud_vpc.vpc.*.id) : var.vpc_id
  cidr_block        = var.vswitch_cidrs[count.index]
  availability_zone = data.alicloud_zones.default.zones[count.index % length(data.alicloud_zones.default.zones)]["id"]
  name = var.vswitch_name_prefix == "" ? format(
  "%s-%s",
  var.example_name,
  format(var.number_format, count.index + 1),
  ) : format(
  "%s-%s",
  var.vswitch_name_prefix,
  format(var.number_format, count.index + 1),
  )
}

resource "alicloud_nat_gateway" "default" {
  count  = var.new_nat_gateway == "true" ? 1 : 0
  vpc_id = var.vpc_id == "" ? join("", alicloud_vpc.vpc.*.id) : var.vpc_id
  name   = var.example_name
}

resource "alicloud_eip" "default" {
  count     = var.new_nat_gateway == "true" ? 1 : 0
  bandwidth = 100
}

resource "alicloud_eip_association" "default" {
  count         = var.new_nat_gateway == "true" ? 1 : 0
  allocation_id = alicloud_eip.default[0].id
  instance_id   = alicloud_nat_gateway.default[0].id
}

resource "alicloud_snat_entry" "default" {
  count         = var.new_nat_gateway == "false" ? 0 : length(var.vswitch_ids) > 0 ? length(var.vswitch_ids) : length(var.vswitch_cidrs)
  snat_table_id = alicloud_nat_gateway.default[0].snat_table_ids
  source_vswitch_id = length(var.vswitch_ids) > 0 ? split(",", join(",", var.vswitch_ids))[count.index % length(split(",", join(",", var.vswitch_ids)))] : length(var.vswitch_cidrs) < 1 ? "" : split(",", join(",", alicloud_vswitch.vswitches.*.id))[count.index % length(split(",", join(",", alicloud_vswitch.vswitches.*.id)))]
  snat_ip = alicloud_eip.default[0].ip_address
}

resource "alicloud_log_project" "log" {
  name    = var.k8s_name_prefix == "" ? format(
  "%s-managed-sls",
  var.example_name,
  ) : format(
  "%s-managed-sls",
  var.k8s_name_prefix,
  )
  description = "created by terraform for managedkubernetes cluster"
}

resource "alicloud_cs_managed_kubernetes" "k8s" {
  count = 1
  name = var.k8s_name_prefix == "" ? format(
  "%s-%s",
  var.example_name,
  format(var.number_format, count.index + 1),
  ) : format(
  "%s-%s",
  var.k8s_name_prefix,
  format(var.number_format, count.index + 1),
  )
  vswitch_ids = [length(var.vswitch_ids) > 0 ? split(",", join(",", var.vswitch_ids))[count.index%length(split(",", join(",", var.vswitch_ids)))] : length(var.vswitch_cidrs) < 1 ? "" : split(",", join(",", alicloud_vswitch.vswitches.*.id))[count.index%length(split(",", join(",", alicloud_vswitch.vswitches.*.id)))]]
  new_nat_gateway       = false
  worker_disk_category  = var.worker_disk_category
  password              = var.ecs_password
  pod_cidr              = var.k8s_pod_cidr
  service_cidr          = var.k8s_service_cidr
  slb_internet_enabled            = true
  install_cloud_monitor = true
  cluster_network_type  = var.cluster_network_type

  depends_on = [alicloud_snat_entry.default]
  worker_instance_types = var.worker_instance_types
  worker_number = var.worker_number
  log_config {
    type = "SLS"
    project = alicloud_log_project.log.name
  }
}
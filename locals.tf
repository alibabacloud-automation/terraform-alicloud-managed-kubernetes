locals {
  k8s_name     = substr(join("-", [var.k8s_name_prefix, random_uuid.this.result]), 0, 63)
  new_vpc_name = "for-${local.k8s_name}"
  new_vpc_tags = {
    Created = "Terraform"
    For     = "modules/terraform-alicloud-managed-kubernetes"
    K8s     = local.k8s_name
  }
  vswitch_ids    = length(var.vswitch_ids) > 0 ? var.vswitch_ids : alicloud_vswitch.new.*.id
  sls_project    = var.sls_project_name == "" ? concat(alicloud_log_project.new.*.id, [""])[0] : var.sls_project_name
  instance_types = length(var.worker_instance_types) > 0 ? var.worker_instance_types : [data.alicloud_instance_types.default.ids.0]
}

resource "random_uuid" "this" {}
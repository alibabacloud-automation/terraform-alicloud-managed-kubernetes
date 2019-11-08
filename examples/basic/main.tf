resource "alicloud_log_project" "log" {
  name        = "tf-example-managed-kubernetes"
  description = "created by terraform for managedkubernetes cluster"
}
// ECS Vpc Resource for Module
resource "alicloud_vpc" "default" {
  cidr_block = "172.16.0.0/16"
  name       = "CreateByTerraform"
}

// ECS Vswitch Resource for Module
resource "alicloud_vswitch" "default" {
  availability_zone = module.k8s.this_data_availability_zone
  cidr_block        = "172.16.0.0/24"
  vpc_id            = alicloud_vpc.default.id
  name              = "CreateByTerraform"
}

module "k8s" {
  source             = "../../"
  create_log_project = false
  example_name       = "tf-example-managed-kubernetes"
  vswitch_ids        = [alicloud_vswitch.default.id]
  log_config = [
    {
      type    = "SLS"
      project = alicloud_log_project.log.name
    }
  ]
}
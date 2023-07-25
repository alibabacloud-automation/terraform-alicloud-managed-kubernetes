data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_vpc" "default" {
  vpc_name   = "tf-example"
  cidr_block = "10.4.0.0/16"
}

resource "alicloud_vswitch" "default" {
  vswitch_name = "tf-example"
  cidr_block   = "10.4.0.0/24"
  vpc_id       = alicloud_vpc.default.id
  zone_id      = data.alicloud_zones.default.zones.0.id
}

module "managed-k8s" {
  source             = "../../"
  k8s_name_prefix    = "tf-example"
  cluster_spec       = "ack.pro.small"
  vswitch_ids        = [alicloud_vswitch.default.id]
  k8s_pod_cidr       = cidrsubnet("10.0.0.0/8", 8, 36)
  k8s_service_cidr   = cidrsubnet("172.16.0.0/16", 4, 7)
  kubernetes_version = "1.24.6-aliyun.1"
  cluster_addons = [
    {
      name   = "flannel",
      config = "",
    },
    {
      name   = "flexvolume",
      config = "",
    },
    {
      name   = "alicloud-disk-controller",
      config = "",
    },
    {
      name   = "logtail-ds",
      config = "{\"IngressDashboardEnabled\":\"true\"}",
    },
    {
      name   = "nginx-ingress-controller",
      config = "{\"IngressSlbNetworkType\":\"internet\"}",
    },
  ]
}

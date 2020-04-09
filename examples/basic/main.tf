variable "profile" {
  default = "default"
}
variable "region" {
  default = "cn-hangzhou"
}
variable "zone_id" {
  default = "cn-hangzhou-e"
}
variable "vpc_cidr" {
  default = "10.1.0.0/21"
}
variable "availability_zones" {
  default = ["cn-hangzhou-e", "cn-hangzhou-f", "cn-hangzhou-g"]
}

provider "alicloud" {
  region  = var.region
  profile = var.profile
}

###########################################
# Data sources to get VPC, vswitch details
###########################################

module "managed-k8s" {
  source          = "../../"
  region          = var.region
  profile         = var.profile
  k8s_name_prefix = "CreateByTerraform1"

  vswitch_ids = [concat(module.kubernetes-networking.this_vswitch_ids, [""])[0]]
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

module "kubernetes-networking" {
  source             = "terraform-alicloud-modules/kubernetes-networking/alicloud"
  region             = var.region
  profile            = var.profile
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  vswitch_cidrs      = [cidrsubnet(var.vpc_cidr, 4, 6)]
  create             = true
}
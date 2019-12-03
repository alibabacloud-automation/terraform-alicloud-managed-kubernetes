Alibaba Cloud Managed Kubernetes Cluster Module  
terraform-alicloud-managed-kubernetes
======================================================

A terraform module used to launch a managed kubernetes cluster on Alibaba Cloud.

These types of the module resource are supported:

- [VPC](https://www.terraform.io/docs/providers/alicloud/r/vpc.html)
- [VSwitch](https://www.terraform.io/docs/providers/alicloud/r/vswitch.html)
- [EIP](https://www.terraform.io/docs/providers/alicloud/r/eip.html)
- [Nat Gateway](https://www.terraform.io/docs/providers/alicloud/r/nat_gateway.html)
- [Snat](https://www.terraform.io/docs/providers/alicloud/r/snat.html)
- [SLS Project](https://www.terraform.io/docs/providers/alicloud/r/log_project.html)
- [Managed Kubernetes](https://www.terraform.io/docs/providers/alicloud/r/cs_managed_kubernetes.html)

Usage
-----

This module used to create a managed kubernetes and it can meet several scenarios by specifying different parameters.

**NOTE:** This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`.
If you have not set them yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.

### 1 Create a new vpc, several new vswitches and a new nat gateway for the cluster.
```hcl
module "managed-k8s" {
  source             = "terraform-alicloud-modules/managed-kubernetes/alicloud"
  profile            = "Your-profile-name"
  
  k8s_name_prefix = "my-managed-k8s-with-new-vpc"
  new_vpc         = true
  vpc_cidr        = "192.168.0.0/16"
  vswitch_cidrs   = [
    "192.168.1.0/24",
    "192.168.2.0/24",
    "192.168.3.0/24",
    "192.168.4.0/24",
  ]
}
```
In this scenario, the module will create a new vpc with `vpc_cidr`, several vswitches with `vswitch_cidrs`, a new nat gateway, 
a new EIP with `new_eip_bandwidth` and several snat entries for vswitches.
  
### 2 Using existing vpc and vswitches by specifying `vswitch_ids`. Setting `new_nat_gateway=true` to add a new nat gateway in the vswitches' vpc.
```hcl
module "managed-k8s" {
  source             = "terraform-alicloud-modules/managed-kubernetes/alicloud"
  profile            = "Your-profile-name"
  
  k8s_name_prefix = "my-managed-k8s-with-new-vpc"
  new_vpc         = false
  vswitch_ids     = [
    "vsw-12345678",
    "vsw-09876537"
  ]
  new_nat_gateway = true
}
```
In this scenario, if setting `new_nat_gateway=false`, you should ensure the specified vswitches can access internet.
In other words, the specified vpc has a nat gateway and there are several snat entries to bind the vswitches and a EIP.

## Conditional creation

This moudle can set [sls project](https://www.terraform.io/docs/providers/alicloud/r/log_project.html) config for this module

1. Create a new sls project with `new_sls_project`:  
    ```hcl
    new_sls_project = true
    ```

1. Using existing sls project with `sls_project_name`:  
    ```hcl
    sls_project_name = "Your-sls-project-name"
    ```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region  | The region ID used to launch this module resources. If not set, it will be sourced from followed by ALICLOUD_REGION environment variable and profile | string  | ''  | no  |
| profile  | The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable. | string  | ''  | no  |
| shared_credentials_file  | This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used. | string  | ''  | no  |
| skip_region_validation  | Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet). | bool  | false | no  |
| new_vpc  | Create a new vpc for this module  | string  | false | no  |
| vpc_cidr  | The cidr block used to launch a new vpc | string  | "192.168.0.0/16"  | no  |
| vswitch_ids  | List Ids of existing vswitch  | string  | []  | yes  |
| vswitch_cidrs  | List cidr blocks used to create several new vswitches when 'new_vpc' is true | string  | ["192.168.1.0/24"]  | yes  |
| availability_zones | List available zone ids used to create several new vswitches when 'vswitch_ids' is not specified. If not set, data source `alicloud_zones` will return one automatically. | list | [] | no |
| new_eip_bandwidth | The bandwidth used to create a new EIP when 'new_vpc' is true | int | 50 | no |
| new_nat_gateway | Seting it to true can create a new nat gateway automatically in a existing VPC. If 'new_vpc' is true, it will be ignored | bool | false|
| cpu_core_count | CPU core count is used to fetch instance types | int | 1 | no |
| memory_size | Memory size used to fetch instance types | int | 2 | no |
| worker_instance_types | The ecs instance type used to launch worker nodes. If not set, data source `alicloud_instance_types` will return one based on `cpu_core_count` and `memory_size` | list | ["ecs.n4.xlarge"] | no |
| worker_disk_category | The system disk category used to launch one or more worker nodes| string | "cloud_efficiency" | no |
| worker_disk_size | The system disk size used to launch one or more worker nodes| int | 40 |no |
| ecs_password | The password of work nodes | string | "Abc12345" | no |
| worker_number | The number of kubernetes cluster work nodes | int | 2 | no |
| k8s_name_prefix | The name prefix used to create managed kubernetes cluster | string | "terraform-alicloud-managed-kubernetes" | no |
| k8s_pod_cidr | The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them. If vpc's cidr block is `172.16.XX.XX/XX`, it had better to `192.168.XX.XX/XX` or `10.XX.XX.XX/XX` | string | "172.20.0.0/16" | no |
| k8s_service_cidr | The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them. Its setting rule is same as `k8s_pod_cidr` | string | "172.21.0.0/20" | no |
| cluster_network_type | Network type, valid options are `flannel` and `terway` | string | "flannel" | no |
| new_sls_project | Create a new sls project for this module | bool | false | no |
| sls_project_name | Specify a existing sls project for this module | string | "" | no |

## Outputs

| Name | Description |
|------|-------------|
| this_k8s_id | The ID of managed kubernetes cluster |
| this_k8s_name | The name of managed kubernetes cluster |
| this_k8s_nodes | List worker nodes of managed kubernetes cluster |
| this_vpc_id  | The ID of VPC  |
| this_vswitch_ids  | List Ids of vswitches  |
| this_security_group_id  | ID of the Security Group used to deploy kubernetes cluster  |
| this_sls_project_name  | The sls project name used to configure cluster |

Terraform version
-----------------
Terraform version 0.12.0 or newer and Provider version 1.57.2 or newer are required for this example to work.

Authors
-------
Created and maintained by Meng Xiaobing(@menglingwei, menglingwei@gmail.com, @xiaozhu36, heguimin36@163.com)

License
-------
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/)



//Autoscaling group
variable "region" {
  description = "The region ID used to launch this module resources. If not set, it will be sourced from followed by ALICLOUD_REGION environment variable and profile."
  default     = ""
}

variable "profile" {
  description = "The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  default     = ""
}
variable "shared_credentials_file" {
  description = "This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  default     = ""
}

variable "skip_region_validation" {
  description = "Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  type        = bool
  default     = false
}

# VPC variables
variable "new_vpc" {
  description = "Create a new vpc for this module."
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc."
  default     = "192.168.0.0/16"
}

# VSwitch variables
variable "vswitch_ids" {
  description = "List Ids of existing vswitch."
  type        = list(string)
  default     = []
}

variable "vswitch_cidrs" {
  description = "List cidr blocks used to create several new vswitches when 'new_vpc' is true."
  type        = list(string)
  default     = ["192.168.1.0/24"]
}

variable "availability_zones" {
  description = "List available zone ids used to create several new vswitches when 'vswitch_ids' is not specified. If not set, data source `alicloud_zones` will return one automatically."
  type        = list(string)
  default     = []
}

variable "new_eip_bandwidth" {
  description = "The bandwidth used to create a new EIP when 'new_vpc' is true."
  default     = 50
}
variable "new_nat_gateway" {
  description = "Seting it to true can create a new nat gateway automatically in a existing VPC. If 'new_vpc' is true, it will be ignored."
  type        = bool
  default     = false
}
# Cluster nodes variables
variable "cpu_core_count" {
  description = "CPU core count is used to fetch instance types."
  default     = 1
}

variable "memory_size" {
  description = "Memory size used to fetch instance types."
  default     = 2
}
variable "worker_instance_types" {
  description = "The ecs instance type used to launch worker nodes. If not set, data source `alicloud_instance_types` will return one based on `cpu_core_count` and `memory_size`."
  type        = list(string)
  default     = ["ecs.n4.xlarge"]
}

variable "worker_disk_category" {
  description = "The system disk category used to launch one or more worker nodes."
  default     = "cloud_efficiency"
}

variable "worker_disk_size" {
  description = "The system disk size used to launch one or more worker nodes."
  default     = 40
}

variable "ecs_password" {
  description = "The password of work nodes."
  default     = "Abc12345"
}

variable "worker_number" {
  description = "The number of kubernetes cluster work nodes."
  default     = 2
}

variable "k8s_name_prefix" {
  description = "The name prefix used to create managed kubernetes cluster."
  default     = "terraform-alicloud-managed-kubernetes"
}

variable "k8s_pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them. If vpc's cidr block is `172.16.XX.XX/XX`, it had better to `192.168.XX.XX/XX` or `10.XX.XX.XX/XX`."
  default     = "172.20.0.0/16"
}

variable "k8s_service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them. Its setting rule is same as `k8s_pod_cidr`."
  default     = "172.21.0.0/20"
}

variable "cluster_network_type" {
  description = "Network type, valid options are `flannel` and `terway`."
  default     = "flannel"
}

variable "new_sls_project" {
  description = "Create a new sls project for this module."
  type        = bool
  default     = false
}
variable "sls_project_name" {
  description = "Specify a existing sls project for this module."
  default     = ""
}
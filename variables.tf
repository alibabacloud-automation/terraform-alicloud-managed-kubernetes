# common variables


variable "region" {
  description = "The region used to launch this module resources."
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
  default     = false
}

variable "filter_with_name_regex" {
  description = "A default filter applied to retrieve existing vswitches and kubernetes clusters by name regex."
  default     = ""
}

variable "filter_with_tags" {
  description = "A default filter applied to retrieve existing vswitches and kubernetes clusters by tags."
  type        = map(string)
  default     = {}
}

variable "filter_with_resource_group_id" {
  description = "A default filter applied to retrieve existing vswitches and kubernetes clusters by resource group id."
  default     = ""
}

variable "availability_zone" {
  description = "The available zone to launch ecs instance and other resources."
  default     = ""
}

variable "example_name" {
  default = "tf-example-managed-kubernetes"
}

# Instance types variables
variable "cpu_core_count" {
  description = "CPU core count is used to fetch instance types."
  default     = 1
}

variable "memory_size" {
  description = "Memory size used to fetch instance types."
  default     = 2
}

# VSwitch variables

variable "vswitch_name_regex" {
  description = "A default filter applied to retrieve existing vswitches by name regex. If not set, `filter_with_name_regex` will be used."
  default     = ""
}

variable "vswitch_tags" {
  description = "A default filter applied to retrieve existing vswitches by tags. If not set, `filter_with_tags` will be used."
  type        = map(string)
  default     = {}
}

variable "vswitch_resource_group_id" {
  description = "A id string to filter vswitches by resource group id."
  default     = ""
}


variable "vswitch_ids" {
  description = "List of existing vswitch id."
  type        = list(string)
  default     = []
}

variable "new_nat_gateway" {
  description = "Whether to create a new nat gateway. In this template, a new nat gateway will create a nat gateway, eip and server snat entries."
  default     = "true"
}

# Cluster nodes variables

variable "worker_instance_types" {
  description = "The ecs instance type used to launch worker nodes. Default from instance typs datasource."
  type        = list(string)
  default     = []
}

variable "worker_disk_category" {
  description = "The system disk category used to launch one or more worker nodes."
  default     = "cloud_efficiency"
}

variable "worker_disk_size" {
  description = "The system disk size used to launch one or more worker nodes."
  default     = "40"
}

variable "ecs_password" {
  description = "The password of instance."
  default     = "Abc12345"
}

variable "worker_number" {
  description = "The number of kubernetes cluster."
  default     = 2
}

variable "k8s_name_prefix" {
  description = "The name prefix used to create several kubernetes clusters. Default to variable `example_name`"
  default     = ""
}

variable "k8s_pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them."
  default     = "172.20.0.0/16"
}

variable "k8s_service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them."
  default     = "172.21.0.0/20"
}

variable "cluster_network_type" {
  description = "Network type, valid options are flannel, terway"
  default     = "flannel"
}

# Log config variables

variable "create_log_project" {
  description = "Whether to create a log project"
  default     = true
}

variable "log_config" {
  description = "A list of one element containing information about the associated log store."
  type        = list(map(string))
  default     = []
}
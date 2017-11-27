#Copyright 2017 Reactive Ops Inc.
#
#Licensed under the Apache License, Version 2.0 (the “License”);
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an “AS IS” BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

## Variables for accessing Aliyun Cloud ##
variable "alicloud_access_key" {}
variable "alicloud_secret_key" {}
variable "alicloud_region" {
  description = "region to deploy to, default is China East 1 (cn-hangzhou)"
  default = "cn-hangzhou"
}

variable "alicloud_azs" {
  description = "comma separated string of availability zones in order of precedence, defaults are all zones for cn-hangzhou"
  default = "cn-hangzhou-b, cn-hangzhou-c, cn-hangzhou-d"

}

variable "az_count" {
  description = "number of active availability zones in the VPC"
  default = "3"
}


## Variables for ESS Groups, Configurations, and Rules ##
variable "ess_scaling_min_size" {
  description = "minimum size for ess groups"
  default = 1
}

variable "ess_scaling_max_size" {
  description = "maximum size for ess groups"
  default = 3
}

variable "ess_sg_id" {
  description = "id of the security group to use for ESS instances"
  default = ""
}

variable "ess_removal_policies" {
  description = "removal policy to use for generated ess groups"
  default = ["OldestInstance", "NewestInstance"]
}

variable "ess_instance_type" {
  description = "instance type to use for ess scaling groups"
  default = "ecs.n4.large"
}

variable "ess_image_name_regex" {
  description = "regex to match against for image name used in ess"
  default     = "^centos_6\\w{1,5}[64].*"
}

variable "ess_loadbalancer_ids" {
  description = "ids of the SLB to assign the ESS to"
  default     = []
}

variable "ess_scalup_cooldown" {
  description = "cooldown period for scaleup rule"
  default     = 300
}
variable "ess_scaledown_cooldown" {
  description = "cooldown period for scaledown rule"
  default     = 300
}

variable "ess_scaling_group_name" {
  description = "name of the scaling group"
  default     = "tf-esg"
}

variable "ess_scaling_config_name" {
  description = "name of the scaling config to create"
  default     = "tf-scalingconfig"
}

variable "ess_scaleup_size" {
  description = "size of scaleup actions"
  default     = 1
}

variable "ess_scaledown_size" {
  description = "size of scaledown actions"
  default     = -1
}

variable "ess_vswitch_ids" {
  type = "list"
  description = "vswitches to create ess groups in"
}

variable "ess_vswitch_names" {
  type = "list"
  description = "vswitch names"
}

variable "ess_user_data" {
  description = "user data to use for green scaling config"
  default = ""
}

variable "ess_keyname" {
  description = "ssh keypair name to use for ess config"
  default = ""
}

variable "ess_tags" {
  description = "tags to apply to ess instances"
  default = {}
}

variable "ess_datadiskblock" {
  description = "data disk for ecs instances"
  default = {
        size   =      "80"
        device =      "/dev/xvdb"
        active =      true
        enable =      true
  }

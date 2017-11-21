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

data "alicloud_images" "ess_image" {
  most_recent = true
  name_regex = "${var.ess_image_name_regex}"
}

resource "alicloud_ess_scaling_group" "esg" {
  provider           = "alicloud.${var.alicloud_region}"
  count              = "${var.az_count}"
  vswitch_id         = "${element(var.ess_vswitch_ids, count.index)}" 
  min_size           = "${var.ess_scaling_min_size}"
  max_size           = "${var.ess_scaling_max_size}"
  scaling_group_name = "${var.ess_scaling_group_name}-${element(var.ess_vswitch_names, count.index)}"
  removal_policies   = "${var.ess_removal_policies}"
  loadbalancer_ids   = [ "${var.ess_loadbalancer_ids}" ]
}

resource "alicloud_ess_scaling_configuration" "esg-config" {
  lifecycle { create_before_destroy = true }
  provider                    = "alicloud.${var.alicloud_region}"
  count                       = "${var.az_count}"
  scaling_group_id            = "${element(alicloud_ess_scaling_group.esg.*.id, count.index)}"
  active                      = true
  enable                      = true
  image_id                    = "${data.alicloud_images.green_image.images.0.id}"
  instance_type               = "${var.ess_instance_type}"
  security_group_id           = "${var.ess_sg_id}"
  user_data                   = "${var.ess_user_data}"
  key_name                    = "${var.ess_keyname}"
  tags                        = "${var.ess_tags}"
  force_delete                = true
}

resource "alicloud_ess_scaling_rule" "scaleup" {
  provider           = "alicloud.${var.alicloud_region}"
  count             = "${var.az_count}"
  scaling_rule_name = "ScaleUp"
  scaling_group_id  = "${element(alicloud_ess_scaling_group.esg.*.id, count.index)}"
  adjustment_type   = "QuantityChangeInCapacity"
  adjustment_value  = "${var.ess_scaleup_size}"
  cooldown          = "${var.ess_scalup_cooldown}"
}

resource "alicloud_ess_scaling_rule" "scaledown" {
  provider           = "alicloud.${var.alicloud_region}"
  count             = "${var.az_count}"
  scaling_rule_name = "ScaleDown"
  scaling_group_id  = "${element(alicloud_ess_scaling_group.esg.*.id, count.index)}"
  adjustment_type   = "QuantityChangeInCapacity"
  adjustment_value  = "${var.ess_scaledown_size}"
  cooldown          = "${var.ess_scaledown_cooldown}"
}

resource "alicloud_ess_scaling_rule" "doublecapacity" {
  provider          = "alicloud.${var.alicloud_region}"
  count             = "${var.az_count}"
  scaling_rule_name = "ScaleUp100pct"
  scaling_group_id  = "${element(alicloud_ess_scaling_group.esg.*.id, count.index)}"
  adjustment_type   = "PercentChangeInCapacity"
  adjustment_value  = 100
}

resource "alicloud_ess_scaling_rule" "halfcapacity" {
  provider          = "alicloud.${var.alicloud_region}"
  count             = "${var.az_count}"
  scaling_rule_name = "ScaleDown50pct"
  scaling_group_id  = "${element(alicloud_ess_scaling_group.esg.*.id, count.index)}"
  adjustment_type   = "PercentChangeInCapacity"
  adjustment_value  = -50
}

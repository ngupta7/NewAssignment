provider "aws" {
  region = "${var.aws_region}"
}

data "aws_caller_identity" "current_user" {}

resource "aws_instance" "instance_no_volume" {
  count                = "${var.instance_name == "test" && chomp(element(split(".", var.instance_type),0)) == "i3" ? 1 : 0}"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  user_data            = "${data.template_file.user_data.rendered}"
  security_groups      = ["${aws_security_group.security_group.id}"]
  key_name             = "prdsvc"
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "instance_with_volume" {
  count                = "${var.instance_name == "test" && chomp(element(split(".", var.instance_type),0)) != "i3" ? 1 : 0}"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  user_data            = "${data.template_file.user_data.rendered}"
  security_groups      = ["${aws_security_group.security_group.id}"]
  key_name             = "prdsvc"
  ebs_block_device { #log ebs volume
    device_name                 = "/dev/sdc"
    volume_type                 = "gp2"
    volume_size                 = "${var.log_volume}"
    encrypted                   = "true"
  }
  ebs_block_device { #data ebs volume
    device_name                 = "/dev/sdb"
    volume_type                 = "gp2"
    volume_size                 = "${var.data_volume}"
    encrypted                   = "true"
  }
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("${var.user_data_file}")}"

  vars {
    instance         = "${var.instance_name}"
    environment     = "${var.env}"
    instance_type   = "${var.instance_type}"
    disk_layout     = "${var.service_name == "data" && chomp(element(split(".", var.instance_type),0)) != "i3" ? var.disk_layout[format("d%s",element(split(".", var.instance_type),0))] : var.disk_layout[element(split(".", var.instance_type),0)]}"
  }
}

resource "aws_security_group" "security_group" {
  name        = "${var.env}-test-securitygrp"
  description = "${var.security_group_description}"
  vpc_id      = "${var.vpc_id}"
  }



resource "aws_security_group_rule" "sg_rule" {
  from_port         = "0"
  protocol          = "all"
  security_group_id = "${aws_security_group.security_group.id}"
  to_port           = "65535"
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/8"]
  description       = "Whitelist all communication in the VPC subnets"
}


resource "aws_security_group_rule" "engress_whitelist" {
  from_port         = "0"
  protocol          = "all"
  security_group_id = "${aws_security_group.security_group.id}"
  to_port           = "0"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress Whitelist"
}


output "instance_name" {
  value = "${element(compact(concat(aws_instance.instance_no_volume.*.name,aws_instance.instance_with_volume.*.name)),0)}"
}

output "device_layout_type" {
  value = "${var.service_name == "data" && chomp(element(split(".", var.instance_type),0)) != "i3" ? var.disk_layout[format("d%s",element(split(".", var.instance_type),0))] : var.disk_layout[element(split(".", var.instance_type),0)]}"
}

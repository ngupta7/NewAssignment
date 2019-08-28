terraform {
  required_version = "0.11.13"
}
module "my_aws_instance" {
  source                      = "./modules/test_instances"
  env                         = "${var.env}"
  instance_name               = "${var.instance_name}"
  security_group_description  = "${var.security_group_description}"
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  log_vol_size                = "${var.log_volume}"
  data_vol_size               = "${var.data_volume}"
  user_data_file              = "${var.instance_user_data_file}"
  subnet_id                   = "${var.subnets}"
}

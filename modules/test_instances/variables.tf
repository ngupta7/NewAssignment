variable "env" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "instance_name" {
type = "string"
}

variable "security_group_description" {
  type = "string"
}

variable "ami" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}


variable "log_volume" {
  type = "string"
  default = "1"
}

variable "data_volume" {
  type = "string"
  default = "2"
}

variable "user_data_file" {
  type = "string"
}



variable "vpc_id" {
  type = "string"
}

variable "source_security_group_id" {
  type = "string"
}
variable "disk_layout" {
  type = "map"
  default = {
    "t2" = "dl1"
    "t3" = "dl2"
    "i3" = "dl3"
  }
}

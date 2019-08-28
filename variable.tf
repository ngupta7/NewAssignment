variable "env" {
  type = "string"
}

variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "region" {
  type = "string"
}



variable "subnets" {
 type = "list"
}

variable "template_path" {
  default = "./templates"
}

variable "ami" {
  type = "string"
}


variable "instance_user_data_file" {
  type = "string"
  default = "instance_user_data"
}

variable "instance_types" {
  type = "string"
  description = "give the instance type"
  default = "i3.large"

  
}

variable "log_volume" {
  type = "string"
  default ="1"

}

variable "data_volume" {
  type = "string"
  default = "2"
   
  }



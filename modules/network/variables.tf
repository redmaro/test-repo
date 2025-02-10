variable "project_name" {
}



variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet_public1_cidr" {
  default = "172.16.0.0/24"
}

variable "subnet_public2_cidr" {
  default = "172.16.1.0/24"
}

variable "subnet_private1_cidr" {
  default = "172.16.2.0/24"
}

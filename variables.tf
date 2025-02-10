variable "region" {
  default = "us-east-1"
}
# 
# variable "vpc_cidr" {
#   default = "172.16.0.0/16"
# }
# 
# variable "subnet_public1_cidr" {
#   default = "172.16.0.0/24"
# }
# 
# variable "subnet_public2_cidr" {
#   default = "172.16.1.0/24"
# }
# 
# variable "subnet_private1_cidr" {
#   default = "172.16.2.0/24"
# }
# 
# variable "project_name" {
#   default = "tp-terraform"
# }

variable "key_name" {
  description = "Nom de la clé SSH pour le bastion et l'application"
  default     = "my-keypair"
}

variable "private_key_path" {
  description = "Chemin de la clé SSH privée"
  default     = "./my-keypair.pem"
}

variable "public_key_path" {
  description = "Chemin de la clé SSH publique"
  default     = "./my-keypair.pub"
}

variable "allow_ssh_from" {
  description = "IP autorisée pour accéder en SSH au bastion"
  default     = ["0.0.0.0/0"]
}

variable "ami" {
  description = "AMI à utiliser pour les instances EC2"
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2
}

variable "instance_type" {
  default = "t2.micro"
}
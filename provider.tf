terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.1"
    }
  }
  backend "s3" {
    bucket = "maro-tp-terraform-bucket"
    key = "terraform/state"
    region = "us-east-1"
    dynamodb_table = "maro-dyndb"
  }
}

# AWS Provider
provider "aws" {
  region = var.region
}

#default-tags {
#    tags = {
#      env = var.env
#    }
#}
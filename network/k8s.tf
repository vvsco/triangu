#===========================================================
# Triangu test task (k8s)
#===========================================================

# common:
provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_region" "current" {}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "triangu-test"
    key    = "network/terraform.tfstate"
  }
}

# remote state:
terraform {
    backend "s3" {
    bucket = "triangu-test"
    key    = "k8s/terraform.tfstate"
  }
}




locals {
  kops_state_bucket_name = "${var.env}-kops-state"
  // Needs to be a FQDN
  kubernetes_cluster_name = data.terraform_remote_state.network.kubernetes_cluster_name
  ingress_ips             = ["10.0.0.100/32", "10.0.0.101/32"]
  vpc_name                = "${var.env}-vpc"

  tags = {
    environment = "${var.env}"
    terraform   = true
  }
}

resource "aws_s3_bucket" "kops_state" {
  bucket        = "${local.kops_state_bucket_name}"
  acl           = "private"
  force_destroy = true
  tags          = "${merge(local.tags)}"
}

resource "aws_security_group" "k8s_common_http" {
  name   = "${local.environment}_k8s_common_http"
  vpc_id = "${module.dev_vpc.vpc_id}"
  tags   = "${merge(local.tags)}"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      #cidr_blocks      = ["0.0.0.0/0"]
      cidr_blocks      = ["${local.ingress_ips}"]
    }
  }
}
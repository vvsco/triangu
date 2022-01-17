#===========================================================
# Triangu test task (network)
#===========================================================

# common:
provider "aws" {
    region = var.region
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
    state = "available"
}

# remote state:
terraform {
    backend "s3" {
        bucket = "triangu-test"
        key    = "network/terraform.tfstate"
    }
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    name = var.env
    cidr = var.vpc_cidr

    azs             = data.aws_availability_zones.available.names
    private_subnets = var.private_subnets_cidrs
    public_subnets  = var.public_subnets_cidrs

    enable_nat_gateway = true
    #enable_vpn_gateway = true
    #single_nat_gateway = false
    #one_nat_gateway_per_az = true
    #reuse_nat_ips       = true

    tags = {
        "kubernetes.io/cluster/${var.kubernetes_cluster_name}" = "shared"
        "Terraform" = "true"
        "Environment" = "${var.env}"
    }
    private_subnet_tags = {"kubernetes.io/role/internal-elb" = true}
    public_subnet_tags = {"kubernetes.io/role/elb" = true}

}

locals {
    kops_state_bucket_name  = "${var.env}-kops-state"
    // Needs to be a FQDN
    kubernetes_cluster_name = var.kubernetes_cluster_name
    ingress_ips             = var.ingress_ips
    vpc_name                = var.env

    tags = {
        environment = "${var.env}"
        terraform   = "true"
    }
}

resource "aws_s3_bucket" "kops_state" {
    bucket        = "${local.kops_state_bucket_name}"
    acl           = "private"
    force_destroy = true
    tags          = "${merge(local.tags)}"
}

resource "aws_security_group" "k8s_common_http" {
    name   = "${var.env}_k8s_common_http"
    vpc_id = "${module.vpc.vpc_id}"
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
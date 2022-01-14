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
#        region = var.region
    }
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        name = "${var.env}-main-vpc"
    }
}

# routers:
resource "aws_internet_gateway" "main-gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        name = "${var.env}-main-gw"
    }
}

# networks:
resource "aws_subnet" "public_subnets" {
    count      = length(var.subnets_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = element(var.subnets_cidrs, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        name = "${var.env}-public-${count.index + 1}"
    }
}
resource "aws_route_table" "public_subnets" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main-gw.id
    }
    tags   = {
        name = "${var.env}-public"
    }
}
resource "aws_route_table_association" "public_routes" {
    count = length(aws_subnet.public_subnets[*].id)
    route_table_id = aws_route_table.public_subnets.id
    subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
}


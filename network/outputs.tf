output "vpc_id" {
    value = module.vpc.vpc_id
}

output "vpc_cidr" {
    value = module.vpc.vpc_cidr_block
}

output "private_subnets_id" {
    value = module.vpc.private_subnets
}

output "private_subnets_cidr" {
    value = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets_id" {
    value = module.vpc.public_subnets
}

output "public_subnets_cidr" {
    value = module.vpc.public_subnets_cidr_blocks
}

output "availability_zones" {
    value = module.vpc.azs
}

output "kubernetes_cluster_name" {
    value = var.kubernetes_cluster_name
}
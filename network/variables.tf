# Common:
variable region {
    description = "Region code from https://awsregion.info/"
    default     = "eu-central-1"
}
variable "env" {default = "triangu-test"}
variable instance_type {default = "t2.micro"}

# Network:
variable vpc_cidr {default = "10.0.0.0/16"}
variable "public_subnets_cidrs" {
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24",
    ]
}
variable private_subnets_cidrs {
    default = [
        "10.0.11.0/24",
        "10.0.21.0/24",
        "10.0.31.0/24",
    ]
}

# kubernetes
variable kubernetes_cluster_name {default = "test-cluster.triangu.local"}

# NAT
variable ingress_ports {
    type        = list
    default     = ["80", "443"]
}

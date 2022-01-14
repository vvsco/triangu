# Common:
variable region {
    description = "Region code from https://awsregion.info/"
    default     = "eu-central-1"
}
variable instance_type {default = "t2.micro"}
variable "env" {default = "test"}


# Network:
variable "vpc_cidr" {default = "10.0.0.0/16"}
variable "subnets_cidrs" {
    default = [
        "10.0.11.0/24",
    ]
}
variable ingress_ports {
    description = "List of open ports for incoming connections, for example [22, 80]"
    type        = list
    default     = ["80", "443"]
}

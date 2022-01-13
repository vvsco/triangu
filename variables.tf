variable region {
    description = "Region code from https://awsregion.info/"
    type        = string
    default     = "eu-central-1"
}

variable instance_type {
    description = "Instance type"
    type        = string
    default     = "t2.micro"
}

variable "vpc_subnet_cidrs" {
    type        = string
    default     = [
        "10.0.0.0/24",
    ]
}



/* variable ingress_ports {
    description = "List of open ports for incoming connections, for example [22, 80]"
    type        = list
    default     = ["22", "80", "443", "8291"]
}

variable ingress_ports_and_desc {
    description = "List of open ports for incoming connections, for example [22, 80]"
    type        = map
    default     = {
        SSH = 22,
        HTTP = 80,
        HTTPS = 443,
        WinBox = 8291
    }
}

variable key_name {
    description = "Name of ssh-key in amazon store"
    type        = string
    default     = "frankfurt_router"
}

variable user_data_file {
    description = "Name of the script file for the initial configuration"
    type        = string
    default     = "user_data.rsc"
}

variable client_data {
    description = "client-data:"
    type        = map
    default     = {
        vpn_server = "0.0.0.0",
        vpn_user = "xRouter",
        vpn_passw = "xRouter"
    }
}

variable client_name {
    description = "Client name"
    type        = string
    default     = "testClient"
}
 */

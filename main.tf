#===========================================================
# Triangu test task
#===========================================================

provider "aws" {
    region     = var.region
}

/* data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
    state = "available"
}
 */

# image: RouterOS CHR
data "aws_ami" "Latest_RouterOS_CHR" {
    most_recent = true
    owners = ["679593333241"]
    filter {
        name = "name"
        values = ["RouterOS CHR *"]
    }
}

# image: Amazon Linux 2 AMI (HVM), SSD Volume Type
data "aws_ami" "Latest_Amazon_Linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
    }
}

# admin password for xRouter
data aws_ssm_parameter router_admin_passw {
    name = "xRouter_admin_password"
    depends_on = [aws_ssm_parameter.AdminPAssw]
}

# random password:
resource random_string RandomPassw {
    length  = 12
    upper   = true
    lower   = true
    number  = true
    special = true
    override_special = "!@#"
    keepers = {
        client = var.client_name
    }
}

# admin password for routers:
resource aws_ssm_parameter AdminPAssw {
    name = "xRouter_admin_password"
    type = "SecureString"
    description = "Admin password for new routers"
    value = random_string.RandomPassw.result
}

resource "aws_instance" "xRouter" {
    #count = 20
    ami = data.aws_ami.Latest_RouterOS_CHR.id   # RouterOS CHR 6.44.3
    #ami = data.aws_ami.Latest_Amazon_Linux.id   # Amazon Linux 2 AMI (HVM), SSD Volume Type
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.xRouterOS.id]
    tags = {
        Name = "xRouter"
        Owner = "test owner"
    }
    user_data = templatefile(var.user_data_file, var.client_data)
    
    lifecycle {
        create_before_destroy = true
        #prevent_destroy = false
        #ignore_changes = ["ami", "user_data"]
    }
}

# nat configuration
resource "aws_security_group" "xRouterOS" {
    name        = "xRouterOS"
    description = "Allow ssh, http, https and winbox"
    tags = {
        Name = "xRouterOS"
        Owner = "test owner"
    }

    dynamic "ingress" {
        for_each = var.ingress_ports
        content {
            from_port        = ingress.value
            to_port          = ingress.value
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}

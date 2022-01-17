# remote state:
terraform {
        backend "s3" {
        bucket = "triangu-test"
        key    = "k8s/terraform.tfstate"
    }
}

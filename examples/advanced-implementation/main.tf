provider "aws" {
  region = "eu-west-1"
}

# Implement the AWS VPC module
module "vpc" {
  source = "../../"

  zone_count                = 3
  env_name                  = "aws-vpc-advanced-example"
  vpc_cidr                  = "10.1.0.0/16"
  vpc_public_subnet_offset  = 1
  vpc_private_subnet_offset = 11
  vpc_data_subnet_offset    = 21
}

# Take the outputs from the module and directly map them to plan outputs
output "outputs" {
  value = "${module.vpc.outputs}"
}

output "outputs-list" {
  value = "${module.vpc.outputs-list}"
}

provider "aws" {
  region = "eu-west-1"
}

# Implement the AWS VPC module
module "vpc" {
  source = "../../"

  zone_count                = 3
  env_name                  = "aws-vpc-advanced-example"
  vpc_cidr_second_octet     = 12
  vpc_public_subnet_prefix  = 4
  vpc_private_subnet_prefix = 5
  vpc_data_subnet_prefix    = 6
}

# Take the outputs from the module and directly map them to plan outputs
output "outputs" {
  value = "${module.vpc.outputs}"
}

output "outputs-list" {
  value = "${module.vpc.outputs-list}"
}

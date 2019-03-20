provider "aws" {
  region = "eu-west-1"
}

# Implement the AWS VPC module
module "vpc" {
  source = "../../"

  zone_count = 2
  env_name   = "aws-vpc-basic-example"
}

# Take the outputs from the module and directly map them to plan outputs
output "outputs" {
  value = "${module.vpc.outputs}"
}

output "outputs-list" {
  value = "${module.vpc.outputs-list}"
}

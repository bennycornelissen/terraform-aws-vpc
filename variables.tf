# AWS region to use
variable "aws_region" {}

# Name our environment. Used for tagging in AWS
variable "env_name" {}

# Amount of AWS zones we want to use for this VPC
variable "zone_count" {
  default = 1
}

# Get available AZs from AWS
data "aws_availability_zones" "available" {}

#
# Our VPC network is configured as follows:
#
# - the supernet is 10.0.0.0/16
# - the second octet is zero by default but can be changed
# - we can identify public, private, and data subnets (classic 3-tier setup)
# - each subnet is assigned a /24 block
# - the third octet is built out of a prefix, indicating the type of subnet, and a counter
#
# As a result, using the default values, the CIDR of the second private subnet would be 10.0.22.0/24
#

variable vpc_cidr_second_octet {
  default = 0
}

variable vpc_public_subnet_prefix {
  default = 1
}

variable vpc_private_subnet_prefix {
  default = 2
}

variable vpc_data_subnet_prefix {
  default = 3
}

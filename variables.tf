data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

variable "env_name" {
  description = "Name for the environment you are creating (e.g. 'lab' or 'prod'). Used for tagging in AWS"
}

variable "zone_count" {
  description = "Amount of Availability Zones (AZs) we want to use"
  default     = 1
}

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
  description = "Second octet of the CIDR block for the VPC (10.x.0.0/16)"
  default     = 0
}

variable vpc_public_subnet_prefix {
  description = "Prefix for public subnets, used in the 3rd octet (10.0.xx.0/24)"
  default     = 1
}

variable vpc_private_subnet_prefix {
  description = "Prefix for private subnets, used in the 3rd octet (10.0.xx.0/24)"
  default     = 2
}

variable vpc_data_subnet_prefix {
  description = "Prefix for data subnets, used in the 3rd octet (10.0.xx.0/24)"
  default     = 3
}

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
# - we use offsets (1/101/201) as a base for calculating subnets.
#
# As a result, using the default values, the CIDR of the second private subnet would be 10.0.102.0/24
#

variable "vpc_cidr" {
  description = "Base CIDR block for the VPC supernet"
  default     = "10.0.0.0/16"
}

variable vpc_public_subnet_offset {
  description = "Offset for calculating public subnets. (10.0.x.0/24)"
  default     = 1
}

variable vpc_private_subnet_offset {
  description = "Offset for calculating private subnets. (10.0.x.0/24)"
  default     = 101
}

variable vpc_data_subnet_offset {
  description = "Offset for calculating data subnets. (10.0.x.0/24)"
  default     = 201
}

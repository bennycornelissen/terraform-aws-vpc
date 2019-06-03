# VPC
resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.env_name}-vpc"
  }
}

# Public subnets
resource "aws_subnet" "public" {
  count = "${var.zone_count}"

  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 8, count.index + var.vpc_public_subnet_offset)}"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.env_name}-vpc public network ${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

# Private subnets
resource "aws_subnet" "private" {
  count = "${var.zone_count}"

  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 8, count.index + var.vpc_private_subnet_offset)}"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${var.env_name}-vpc private network ${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

# Data subnets
resource "aws_subnet" "data" {
  count = "${var.zone_count}"

  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 8, count.index + var.vpc_data_subnet_offset)}"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${var.env_name}-vpc data network ${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

# RDS Subnet group
resource "aws_db_subnet_group" "rds" {
  # only create an RDS Subnet group if we are in more than one AZ
  count = "${var.zone_count == 1 ? 0 : 1}"

  name        = "${var.env_name}-data-rds"
  description = "${var.env_name}-vpc - Subnet group for RDS"
  subnet_ids  = ["${aws_subnet.data.*.id}"]
}

#
# Routing:
# - Gateways & Routers
# - Route tables
# - Route table entries
# - Route table associations
#

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.env_name} - internet gateway"
  }
}

# NAT Gateway
resource "aws_eip" "nat" {
  vpc = true

  tags {
    Name = "${var.env_name} - NAT GW EIP"
  }
}

resource "aws_nat_gateway" "default" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.0.id}"

  tags {
    Name = "${var.env_name} - NAT GW"
  }

  depends_on = ["aws_internet_gateway.default"]
}

# Public route table:
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.env_name} - public route table"
  }
}

# Default rule for public table, sending all unknown destinations to the internet gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Private route table
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.env_name} - private route table"
  }
}

# Default rule for private table, sending all unknown destinations to the NAT gateway
resource "aws_route" "private_internet_access" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.default.id}"
}

# Data layer route table
resource "aws_route_table" "data" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.env_name} - data route table"
  }
}

# Route table association for Public networks
resource "aws_route_table_association" "public" {
  count = "${var.zone_count}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

# Route table association for Private networks
resource "aws_route_table_association" "private" {
  count = "${var.zone_count}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

# Route table association for Data networks
resource "aws_route_table_association" "data" {
  count = "${var.zone_count}"

  subnet_id      = "${element(aws_subnet.data.*.id, count.index)}"
  route_table_id = "${aws_route_table.data.id}"
}

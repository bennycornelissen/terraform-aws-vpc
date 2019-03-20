# Module outputs that are strings
output "outputs" {
  value = {
    aws_region             = "${var.aws_region}"
    data_route_table_id    = "${aws_route_table.data.id}"
    env_name               = "${var.env_name}"
    internet_gateway_id    = "${aws_internet_gateway.default.id}"
    nat_gateway_eip        = "${aws_nat_gateway.default.public_ip}"
    public_route_table_id  = "${aws_route_table.public.id}"
    private_route_table_id = "${aws_route_table.private.id}"
    rds_subnet_group_name  = "${join(",", aws_db_subnet_group.rds.*.name)}"
    vpc_cidr_block         = "${aws_vpc.default.cidr_block}"
    vpc_id                 = "${aws_vpc.default.id}"
    zone_count             = "${var.zone_count}"
  }
}

# Module outputs that are lists
output "outputs-list" {
  value = {
    data_subnet_cidr_blocks    = ["${aws_subnet.data.*.cidr_block}"]
    data_subnet_ids            = ["${aws_subnet.data.*.id}"]
    private_subnet_cidr_blocks = ["${aws_subnet.private.*.cidr_block}"]
    private_subnet_ids         = ["${aws_subnet.private.*.id}"]
    public_subnet_cidr_blocks  = ["${aws_subnet.public.*.cidr_block}"]
    public_subnet_ids          = ["${aws_subnet.public.*.id}"]
  }
}

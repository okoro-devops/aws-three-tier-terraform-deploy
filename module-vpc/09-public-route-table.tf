# ==========================
# Default Route Table (Public)
# ==========================
data "aws_route_table" "default" {
  vpc_id = aws_vpc.main.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

resource "aws_ec2_tag" "tag_default_route_table" {
  resource_id = data.aws_route_table.default.id
  key         = "Name"
  value       = "${var.environment}-public-route-table"
}

resource "aws_route" "default_route" {
  route_table_id         = data.aws_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
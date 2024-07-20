resource "aws_eip" "nat_gateway_eip" {
}


resource "aws_nat_gateway" "user_nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = var.public_subnet_id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.user_nat_gateway.id
  }

  tags = {
    Name = "${var.prefix}-private-rtb-${var.suffix}"
    Tier = "private"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = toset(var.private_subnets_ids)
  route_table_id = aws_route_table.private.id
  subnet_id      = each.key
}


resource "aws_vpc" "vpc_tf" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-vpc-${var.suffix}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_tf.id
  tags = {
    Name = "${var.prefix}-igw-${var.suffix}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count             = min(3, length(data.aws_availability_zones.available.names))
  vpc_id                  = aws_vpc.vpc_tf.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.vpc_tf.cidr_block, 8, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-subnet-public-${data.aws_availability_zones.available.names[count.index]}-${var.suffix}"
    Tier = "public"
  }
}

resource "aws_subnet" "private" {
  count             = min(3, length(data.aws_availability_zones.available.names))
  vpc_id            = aws_vpc.vpc_tf.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.vpc_tf.cidr_block, 8, count.index + 3)

  tags = {
    Name = "${var.prefix}-subnet-private-${data.aws_availability_zones.available.names[count.index]}-${var.suffix}"
    Tier = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-public-rtb-${var.suffix}"
    Tier = "public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

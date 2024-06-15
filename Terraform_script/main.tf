# main.tf

# Specify the provider
provider "aws" {
  region = "us-east-1" 
}

# VPC
resource "aws_vpc" "euro_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "euro_vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "euro_igw" {
  vpc_id = aws_vpc.euro_vpc.id

  tags ={
    Name = "euro_igw"
  }
      
}

# Public Subnet
resource "aws_subnet" "euro_public_subnet" {
  vpc_id            = aws_vpc.euro_vpc.id
  availability_zone = "us-east-1a"
  cidr_block        =  "10.0.1.0/24"
  
  tags ={
    Name = "euro_public_subnet"
  }
}

# Private Subnet AZ-b
resource "aws_subnet" "euro_private_subnet_b" {
  vpc_id            = aws_vpc.euro_vpc.id
  availability_zone = "us-east-1b"
  cidr_block        =  "10.0.2.0/24"
  
  tags ={
    Name = "euro_private_subnet_b"
  }
}

# Private Subnet AZ-c
resource "aws_subnet" "euro_private_subnet_c" {
  vpc_id            = aws_vpc.euro_vpc.id
  availability_zone = "us-east-1c"
  cidr_block        =  "10.0.3.0/24"
  
  tags ={
    Name = "euro_private_subnet_c"
  }
}

# Route Table Public
resource "aws_route_table" "euro_public_route_table" {
  vpc_id = aws_vpc.euro_vpc.id

  tags  = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "euro_public_route" {
  subnet_id       = aws_subnet.euro_public_subnet.id
  route_table_id  = aws_route_table.euro_public_route_table.id  
}

resource "aws_route" "public" {
  route_table_id          = aws_route_table.euro_public_route_table.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.euro_igw.id
}


#Bastion

# Security Group 
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.euro_vpc.id
    
  tags = {
    Name = "bastion_sg"
  }
}

resource "aws_security_group_rule" "bastion_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

# Key Pair
resource "aws_key_pair" "bastion_key" {
  key_name = "bastion_key"
  public_key = var.key_pair
}

# Bastion Instance
resource "aws_instance" "euro_bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.euro_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true 
  key_name                    = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "euro_bastion"
  }  
}


# Dynamo DB
resource "aws_dynamodb_table" "eurovision_votes" {
  name           = "EurovisionVotes"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "country"
  range_key      = "userId"

  attribute {
    name = "country"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

    # Índice Secundario Global (GSI)
  global_secondary_index {
    name               = "userId-country-index"
    hash_key           = "userId"
    range_key          = "country"
    read_capacity      = var.read_capacity
    write_capacity     = var.write_capacity
    projection_type    = "ALL"
  }

  tags = {
    Name        = "EurovisionVotes"
    Environment = "Production"
  }
}


# Users

# ALB Security group
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.euro_vpc.id
    
  tags = {
    Name = "alb_sg"
  }
}

resource "aws_security_group_rule" "alb_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# ALB
resource "aws_lb" "users_alb" {
  name                = "users-alb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.alb_sg.id]
  subnets             = [aws_subnet.euro_public_subnet.id]  
}


# resource "aws_launch_template" "users_launch_template" {
#   name            = "user_launch_template"
#   image_id        = data.aws_ami.amazon_linux.id
#   instance_type   = var.users_instance_type
#   security_group_names = [aws_security_group.bastion_sg.name]
    
# }

# resource "aws_autoscaling_group" "users_asg" {
  
# }

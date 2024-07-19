resource "aws_security_group" "bastion-tf-sg" {
  name        = "bastion-${var.suffix}-sg"
  description = "Security group for bastion server"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH connection."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my-ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-bastion-sg"
  }
}

resource "aws_security_group" "users-tf-sg" {
  name        = "users-tf-sg"
  description = "Security group for users server"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH connection."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion-tf-sg.id]
  }

  ingress {
    description = "HTTP app security group."
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    security_groups = [var.elb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-users-${var.suffix}-sg"
  }
}

resource "aws_security_group" "votes-tf-sg" {
  name        = "votes-tf-sg"
  description = "Security group for votes server"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH connection."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion-tf-sg.id]
  }

  ingress {
    description = "HTTP app security group."
    from_port   = 9002
    to_port     = 9002
    protocol    = "tcp"
    security_groups = [var.elb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-votes-${var.suffix}-sg"
  }
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] 
}


resource "tls_private_key" "users" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.users.private_key_pem
  filename = "${path.module}/users-${var.suffix}.pem"
}

resource "aws_key_pair" "users-key" {
  key_name   = "users-key"
  public_key = tls_private_key.users.public_key_openssh
}

resource "aws_instance" "bastion-tf" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t4g.micro"
  subnet_id     = var.public_subnet_ip
  vpc_security_group_ids = [aws_security_group.bastion-tf-sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.users-key.key_name
  iam_instance_profile = var.instance_profile_name
  user_data = filebase64("${path.module}/installation.sh")
  tags = {
    Name = "${var.prefix}-bastion-${var.suffix}"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion-tf.id
}


resource "aws_instance" "users-tf" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t4g.micro"
  subnet_id     = var.public_subnet_ip
  vpc_security_group_ids = [aws_security_group.users-tf-sg.id]
  key_name = aws_key_pair.users-key.key_name
  iam_instance_profile = var.instance_profile_name
  user_data = filebase64("${path.module}/installation.sh")
  tags = {
    Name = "${var.prefix}-users-${var.suffix}"
  }
}

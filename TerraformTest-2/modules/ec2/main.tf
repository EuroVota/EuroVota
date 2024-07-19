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
    description     = "SSH connection."
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-tf-sg.id]
  }

  ingress {
    description     = "HTTP app security group."
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "users" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.users.private_key_pem
  filename = "${path.module}/bastion-${var.suffix}.pem"
}

resource "aws_key_pair" "bastion-key" {
  key_name   = "bastion-key"
  public_key = tls_private_key.users.public_key_openssh
}

resource "aws_instance" "bastion-tf" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_ip
  vpc_security_group_ids      = [aws_security_group.bastion-tf-sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion-key.key_name
  iam_instance_profile        = var.instance_profile_name
  tags = {
    Name = "${var.prefix}-bastion-${var.suffix}"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion-tf.id
}


data "aws_ami" "aws-23-docker" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Aws-2023-docker-arm64*"]
  }
}

resource "aws_launch_template" "users-launch-template" {
  name                   = "${var.prefix}-users-launch-template-${var.suffix}"
  instance_type          = "t4g.micro"
  image_id               = data.aws_ami.aws-23-docker.id
  key_name               = aws_key_pair.bastion-key.key_name
  update_default_version = true

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [aws_security_group.users-tf-sg.id]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  user_data = filebase64("${path.module}/init_users.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.prefix}-users-launch-template-${var.suffix}"
    }
  }
}

resource "aws_autoscaling_group" "users-asg" {
  name                = "${var.prefix}-users-asg-${var.suffix}"
  vpc_zone_identifier = [var.private_subnets_ids[0], var.private_subnets_ids[1]]

  target_group_arns = [var.users_tg_arn]

  desired_capacity = 1
  max_size         = 4
  min_size         = 0

  max_instance_lifetime = 60 * 60 * 24 * 7

  capacity_rebalance = true

  mixed_instances_policy {

    instances_distribution {
      // prioritized, lowest-price
      on_demand_allocation_strategy = "prioritized"
      // Minimum number of on-demand/reserved nodes
      on_demand_base_capacity = 1
      // Once that minimum has been granted, percentage of on-demand for
      // the rest of the total capacity
      on_demand_percentage_above_base_capacity = 25
      // lowest-price, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized
      spot_allocation_strategy = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.users-launch-template.id
      }

      override {
        instance_type     = "t4g.micro"
        weighted_capacity = "1"
      }

      override {
        instance_type     = "t4g.small"
        weighted_capacity = "2"
      }

      override {
        instance_type     = "t4g.medium"
        weighted_capacity = "2"
      }
    }
  }
}

resource "aws_security_group" "votes-tf-sg" {
  name        = "votes-tf-sg"
  description = "Security group for votes server"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH connection."
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-tf-sg.id]
  }

  ingress {
    description     = "HTTP app security group."
    from_port       = 9002
    to_port         = 9002
    protocol        = "tcp"
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

resource "aws_launch_template" "votes-launch-template" {
  name                   = "${var.prefix}-votes-launch-template-${var.suffix}"
  instance_type          = "t4g.micro"
  image_id               = data.aws_ami.aws-23-docker.id
  key_name               = aws_key_pair.bastion-key.key_name
  update_default_version = true

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [aws_security_group.votes-tf-sg.id]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  user_data = filebase64("${path.module}/init_votes.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.prefix}-votes-launch-template-${var.suffix}"
    }
  }
}

resource "aws_autoscaling_group" "votes-asg" {
  name                = "${var.prefix}-votes-asg-${var.suffix}"
  vpc_zone_identifier = [var.private_subnets_ids[0], var.private_subnets_ids[1]]

  target_group_arns = [var.votes_tg_arn]

  desired_capacity = 1
  max_size         = 4
  min_size         = 0

  max_instance_lifetime = 60 * 60 * 24 * 7

  capacity_rebalance = true

  mixed_instances_policy {

    instances_distribution {
      // prioritized, lowest-price
      on_demand_allocation_strategy = "prioritized"
      // Minimum number of on-demand/reserved nodes
      on_demand_base_capacity = 1
      // Once that minimum has been granted, percentage of on-demand for
      // the rest of the total capacity
      on_demand_percentage_above_base_capacity = 25
      // lowest-price, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized
      spot_allocation_strategy = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.votes-launch-template.id
      }

      override {
        instance_type     = "t4g.micro"
        weighted_capacity = "1"
      }

      override {
        instance_type     = "t4g.small"
        weighted_capacity = "2"
      }

      override {
        instance_type     = "t4g.medium"
        weighted_capacity = "2"
      }
    }
  }
}
resource "aws_launch_template" "users-launch-template-tf" {

  name = "users-launch-template-tf"
  image_id = var.ami_id
  instance_type = "t4g.micro"

  key_name = "users-key" 
  vpc_security_group_ids = [var.users_sg_id] 

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  iam_instance_profile { 
    name = var.instance_profile_name
  }

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.prefix}-users_asg-${var.suffix}"
    }
  }

  user_data = filebase64("${path.module}/users.sh")
}

resource "aws_launch_template" "votes-launch-template-tf" {

  name = "votes-launch-template-tf"
  image_id = var.ami_id
  instance_type = "t4g.micro"

  key_name = "users-key" 
  vpc_security_group_ids = [var.votes_sg_id]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  iam_instance_profile { 
    name = var.instance_profile_name
  }

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.prefix}-votes_asg-${var.suffix}"
    }
  }

  # user_data = filebase64("${path.module}/connect_ecr.sh")
}

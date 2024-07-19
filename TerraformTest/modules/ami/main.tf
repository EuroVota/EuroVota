resource "aws_ami_from_instance" "users_ami_tf" {
  name               = "users_ami_tf"
  source_instance_id = var.ec2_id
}

resource "aws_iam_instance_profile" "lab-instance-profile" {
  name = "LabInstanceProfile"
  path = "/"
  role = "LabRole"
}
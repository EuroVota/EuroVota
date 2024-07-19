data "aws_iam_instance_profile" "lab-instance-profile" {
  name = "LabInstanceProfile"
}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}
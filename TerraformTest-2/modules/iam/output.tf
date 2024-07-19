output "instance_profile_name" {
  value = data.aws_iam_instance_profile.lab-instance-profile.name
}

output "role_name" {
  value = data.aws_iam_role.lab_role.name
}

output "role_arn" {
  value = data.aws_iam_role.lab_role.arn
}
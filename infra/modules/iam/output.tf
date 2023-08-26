output "instance_role_arn" {
  value = aws_iam_role.instance_role.arn
}

output "access_role_arn" {
  value = aws_iam_role.access_role.arn
}

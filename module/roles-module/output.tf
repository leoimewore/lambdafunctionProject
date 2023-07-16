output "arns" {
  value = [
    for parts in [for arn in data.aws_iam_roles.roles.arns : split("/", arn)] :
    format("%s/%s", parts[0], element(parts, length(parts) - 1))
  ]
}
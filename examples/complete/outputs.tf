output "iam_role_arn" {
  description = "ARN of the IAM role."
  value       = module.aws_federation_github.iam_role_arn
}

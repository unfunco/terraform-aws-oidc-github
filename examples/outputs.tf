output "iam_role_arn" {
  description = "ARN of the IAM role."
  value       = module.aws_oidc_gitlab.iam_role_arn
}

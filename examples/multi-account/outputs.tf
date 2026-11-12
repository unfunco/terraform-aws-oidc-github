output "github_actions_role_arn" {
  description = "Use as role-to-assume in the first configure-aws-credentials step."
  value       = module.oidc_github.iam_role_arn
}

output "workload_role_arn" {
  description = "Use as role-to-assume in the second, chained configure-aws-credentials step."
  value       = aws_iam_role.workload.arn
}

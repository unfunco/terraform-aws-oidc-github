// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

output "iam_role_arn" {
  depends_on  = [aws_iam_role.github]
  description = "ARN of the IAM role."
  value       = var.enabled ? aws_iam_role.github[0].arn : ""
}

output "iam_role_name" {
  depends_on  = [aws_iam_role.github]
  description = "Name of the IAM role."
  value       = var.enabled ? aws_iam_role.github[0].name : ""
}

output "oidc_provider_arn" {
  depends_on  = [aws_iam_openid_connect_provider.github]
  description = "ARN of the OIDC provider."
  value       = var.enabled && var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : ""
}

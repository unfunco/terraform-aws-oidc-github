// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

output "iam_role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.github.arn
}

output "iam_role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.github.name
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC provider."
  value       = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn
}

// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

output "assume_role_policy_document" {
  description = "The assume role policy document that can be attached to your IAM roles."
  value       = local.create_oidc_provider ? data.aws_iam_policy_document.assume_role[0] : ""
}

output "iam_role_arn" {
  description = "The ARN of the IAM role."
  value       = local.create_iam_role ? aws_iam_role.github[0].arn : ""
}

output "iam_role_name" {
  description = "The name of the IAM role."
  value       = local.create_iam_role ? aws_iam_role.github[0].name : ""
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC provider."
  value       = local.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn
}

output "oidc_provider_url" {
  description = "The URL of the OIDC provider."
  value       = local.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].url : data.aws_iam_openid_connect_provider.github[0].url
}

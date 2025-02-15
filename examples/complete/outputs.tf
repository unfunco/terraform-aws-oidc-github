// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

output "iam_role_arn" {
  description = "ARN of the IAM role."
  value       = module.aws_oidc_github.iam_role_arn
}

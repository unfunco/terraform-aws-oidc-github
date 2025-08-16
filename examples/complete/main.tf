// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

provider "aws" {
  default_tags {}
}

module "aws_oidc_github" {
  source = "../../"

  additional_audiences            = var.additional_audiences
  additional_thumbprints          = var.additional_thumbprints
  attach_read_only_policy         = var.attach_read_only_policy
  create_oidc_provider            = var.create_oidc_provider
  dangerously_attach_admin_policy = var.dangerously_attach_admin_policy
  enterprise_slug                 = var.enterprise_slug
  iam_role_force_detach_policies  = var.force_detach_policies
  iam_role_name                   = var.iam_role_name
  iam_role_path                   = var.iam_role_path
  iam_role_permissions_boundary   = var.iam_role_permissions_boundary
  iam_role_policy_arns            = var.iam_role_policy_arns
  github_repositories             = var.github_repositories
  iam_role_max_session_duration   = var.max_session_duration
  tags                            = var.tags

  iam_role_inline_policies = {
    "example_inline_policy" : data.aws_iam_policy_document.example.json
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::amzn-s3-demo-bucket/*"]
  }
}

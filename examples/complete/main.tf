provider "aws" {
  region = var.region
}

module "aws_oidc_github" {
  source = "../../"

  enabled = var.enabled

  additional_thumbprints        = var.additional_thumbprints
  attach_admin_policy           = var.attach_admin_policy
  attach_read_only_policy       = var.attach_read_only_policy
  create_oidc_provider          = var.create_oidc_provider
  enterprise_slug               = var.enterprise_slug
  force_detach_policies         = var.force_detach_policies
  iam_role_name                 = var.iam_role_name
  iam_role_path                 = var.iam_role_path
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_policy_arns          = var.iam_role_policy_arns
  github_repositories           = var.github_repositories
  max_session_duration          = var.max_session_duration
  tags                          = var.tags

  iam_role_inline_policies = {
    "example_inline_policy" : data.aws_iam_policy_document.example.json
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["dynamodb:CreateTable"]
  }
}

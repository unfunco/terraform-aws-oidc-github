provider "aws" {
  region = var.region
}

module "aws_oidc_github" {
  source = "../../"

  enabled = var.enabled

  attach_admin_policy           = var.attach_admin_policy
  attach_read_only_policy       = var.attach_read_only_policy
  create_oidc_provider          = var.create_oidc_provider
  force_detach_policies         = var.force_detach_policies
  github_thumbprint             = var.github_thumbprint
  iam_policy_name               = var.iam_policy_name
  iam_policy_path               = var.iam_policy_path
  iam_role_name                 = var.iam_role_name
  iam_role_path                 = var.iam_role_path
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_policy_arns          = var.iam_role_policy_arns
  github_organisation           = var.github_organisation
  github_repositories           = var.github_repositories
  max_session_duration          = var.max_session_duration
  tags                          = var.tags
}

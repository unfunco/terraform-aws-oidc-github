module "aws_oidc_gitlab" {
  source = "../"


  attach_admin_policy     = var.attach_admin_policy
  create_oidc_provider    = var.create_oidc_provider
  aws_managed_policy_arns = var.aws_managed_policy_arns
  gitlab_url              = var.gitlab_url
  audience                = var.audience
  match_field             = var.match_field
  match_value             = var.match_value
}
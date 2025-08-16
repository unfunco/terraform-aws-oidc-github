provider "aws" {}

module "oidc_github" {
  source = "../.."

  attach_lambda_full_access_policy = true
  github_repositories              = var.github_repositories
}

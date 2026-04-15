provider "aws" {}

module "oidc_github" {
  source = "../.."

  github_subjects       = var.github_subjects
  iam_role_policy_names = ["ReadOnlyAccess"]
}

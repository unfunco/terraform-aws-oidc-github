provider "aws" {}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = "unfunco"
  environment = "test"
  name        = "terraform-aws-oidc-github"
}

module "oidc_github" {
  source = "../.."

  create_iam_role     = false
  github_repositories = var.github_repositories
}

resource "aws_iam_role" "network" {
  assume_role_policy = module.oidc_github.assume_role_policy
  description        = "Assumed by GitHub Actions to manage to network resources."
  name               = join("-", [module.label.id, "network"])
}

resource "aws_iam_role_policy_attachment" "vpc_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  role       = aws_iam_role.network.name
}

resource "aws_iam_role" "storage" {
  assume_role_policy = module.oidc_github.assume_role_policy
  description        = "Assumed by GitHub Actions to manage storage resources."
  name               = join("-", [module.label.id, "storage"])
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.storage.name
}

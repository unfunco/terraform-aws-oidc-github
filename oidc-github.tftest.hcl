provider "aws" {
  region = "eu-west-1"
}

run "create_nothing" {
  variables {
    create = false
  }

  command = plan

  assert {
    condition     = length(aws_iam_openid_connect_provider.github) == 0
    error_message = "OIDC provider was created when it should not have been"
  }

  assert {
    condition     = length(aws_iam_role.github) == 0
    error_message = "IAM role was created when it should not have been"
  }
}

run "create_oidc_provider_only" {
  variables {
    create               = true
    create_iam_role      = false
    create_oidc_provider = true
    github_repositories  = ["unfunco/terraform-aws-oidc-github"]
  }

  command = plan

  assert {
    condition     = length(aws_iam_openid_connect_provider.github) == 1
    error_message = "OIDC provider was not created when it should have been"
  }

  assert {
    condition     = length(aws_iam_role.github) == 0
    error_message = "IAM role was created when it should not have been"
  }
}

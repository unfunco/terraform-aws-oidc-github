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
    create_iam_role     = false
    github_repositories = ["unfunco/terraform-aws-oidc-github"]
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

run "sub_claim_default_branch" {
  variables {
    github_repositories = ["unfunco/terraform-aws-oidc-github"]
  }

  command = plan

  assert {
    condition = contains(
      jsondecode(output.assume_role_policy).Statement[0].Condition.StringLike["token.actions.githubusercontent.com:sub"],
      "repo:unfunco/terraform-aws-oidc-github:ref:refs/heads/main"
    )
    error_message = "Sub claim should include ref:refs/heads/main for default branch"
  }
}

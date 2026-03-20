// SPDX-FileCopyrightText: 2026 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

provider "aws" {
  access_key                  = "mock"
  region                      = "eu-west-1"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

mock_provider "tls" {
  override_during = plan

  mock_data "tls_certificate" {
    defaults = {
      certificates = [
        {
          sha1_fingerprint = "6938fd4d98bab03faadb97b34396831e3780aea1"
        }
      ]
    }
  }
}

override_data {
  override_during = plan

  target = data.aws_partition.this
  values = {
    dns_suffix = "amazonaws.com"
    partition  = "aws"
  }
}

override_data {
  override_during = plan

  target = data.aws_iam_openid_connect_provider.github
  values = {
    arn = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
    url = "https://token.actions.githubusercontent.com"
  }
}

override_resource {
  override_during = plan

  target = aws_iam_openid_connect_provider.github
  values = {
    arn = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
  }
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
      flatten([
        jsondecode(data.aws_iam_policy_document.assume_role[0].json).Statement[0].Condition.StringLike["token.actions.githubusercontent.com:sub"],
      ]),
      "repo:unfunco/terraform-aws-oidc-github:ref:refs/heads/main"
    )
    error_message = "Sub claim should include ref:refs/heads/main for default branch"
  }
}

run "sub_claim_preserves_explicit_ref" {
  variables {
    github_repositories = ["unfunco/terraform-aws-oidc-github:ref:refs/tags/v*"]
  }

  command = plan

  assert {
    condition = flatten([
      jsondecode(data.aws_iam_policy_document.assume_role[0].json).Statement[0].Condition.StringLike["token.actions.githubusercontent.com:sub"],
      ]) == [
      "repo:unfunco/terraform-aws-oidc-github:ref:refs/tags/v*",
    ]
    error_message = "Explicit refs should be preserved without appending the default branch"
  }
}

run "aud_claim_includes_additional_audiences" {
  variables {
    additional_audiences = ["https://github.com/unfunco"]
    github_repositories  = ["unfunco/terraform-aws-oidc-github"]
  }

  command = plan

  assert {
    condition = toset(
      flatten([
        jsondecode(data.aws_iam_policy_document.assume_role[0].json).Statement[0].Condition.StringEquals["token.actions.githubusercontent.com:aud"],
      ])
      ) == toset([
        "sts.amazonaws.com",
        "https://github.com/unfunco",
    ])
    error_message = "Audience claim should include sts.amazonaws.com and any additional audiences"
  }
}

run "create_role_with_existing_oidc_provider" {
  variables {
    create_oidc_provider = false
    github_repositories  = ["unfunco/terraform-aws-oidc-github"]
  }

  command = plan

  assert {
    condition     = length(aws_iam_openid_connect_provider.github) == 0
    error_message = "OIDC provider resource should not be created when create_oidc_provider is false"
  }

  assert {
    condition     = length(aws_iam_role.github) == 1
    error_message = "IAM role should still be created when reusing an existing OIDC provider"
  }

  assert {
    condition     = output.oidc_provider_arn == "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
    error_message = "OIDC provider output should expose the ARN of the existing provider"
  }
}

run "custom_policy_attachments_are_keyed_by_generated_arn" {
  variables {
    github_repositories = ["unfunco/terraform-aws-oidc-github"]
    iam_role_policy_names = [
      "AmazonS3FullAccess",
      "ReadOnlyAccess",
      "AmazonS3FullAccess",
    ]
  }

  command = plan

  assert {
    condition = toset(keys(aws_iam_role_policy_attachment.custom)) == toset([
      "arn:aws:iam::aws:policy/AmazonS3FullAccess",
      "arn:aws:iam::aws:policy/ReadOnlyAccess",
    ])
    error_message = "Custom policy attachments should be keyed by generated managed policy ARN rather than input position"
  }

  assert {
    condition     = length(aws_iam_role_policy_attachment.custom) == 2
    error_message = "Duplicate custom policy names should not create duplicate attachment instances"
  }
}

run "custom_policy_names_reject_full_arns" {
  variables {
    github_repositories   = ["unfunco/terraform-aws-oidc-github"]
    iam_role_policy_names = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  }

  command = plan

  expect_failures = [var.iam_role_policy_names]
}

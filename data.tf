// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test = "StringLike"
      values = [
        for repo in var.github_repositories :
        "repo:%{if length(regexall(":+", repo)) > 0}${repo}%{else}${repo}:*%{endif}"
      ]
      variable = "token.actions.githubusercontent.com:sub"
    }

    condition {
      test = "StringEquals"
      values = var.additional_audiences != null ? concat(
        [local.audience],
        var.additional_audiences,
      ) : [local.audience]
      variable = "token.actions.githubusercontent.com:aud"
    }

    principals {
      identifiers = ["${local.oidc_provider_arn}%{if var.enterprise_slug != ""}/${var.enterprise_slug}%{endif}"]
      type        = "Federated"
    }
  }

  version = "2012-10-17"
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.enabled && !var.create_oidc_provider ? 1 : 0

  url = "https://token.actions.githubusercontent.com%{if var.enterprise_slug != ""}/${var.enterprise_slug}%{endif}"
}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

data "aws_partition" "this" {
  count = var.create ? 1 : 0
}

data "aws_iam_policy_document" "assume_role" {
  count = var.create ? 1 : 0

  version = "2012-10-17"

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
        [format("sts.%v", data.aws_partition.this[0].dns_suffix)],
        var.additional_audiences,
      ) : [format("sts.%v", data.aws_partition.this[0].dns_suffix)]
      variable = "token.actions.githubusercontent.com:aud"
    }

    principals {
      identifiers = ["${local.oidc_provider_arn}%{if var.enterprise_slug != ""}/${var.enterprise_slug}%{endif}"]
      type        = "Federated"
    }
  }
}

data "aws_iam_openid_connect_provider" "github" {
  count = !local.create_oidc_provider ? 1 : 0

  url = format(
    "https://token.actions.githubusercontent.com%v",
    var.enterprise_slug != "" ? "/${var.enterprise_slug}" : "",
  )
}

data "tls_certificate" "github" {
  count = local.create_oidc_provider ? 1 : 0

  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

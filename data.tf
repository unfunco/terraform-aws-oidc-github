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
        "repo:${repo}${length(regexall(":+", repo)) > 0 ? "" : ":${var.default_branch_name == "*" ? "*" : "ref:refs/heads/${var.default_branch_name}"}"}"
      ]
      variable = "${local.oidc_provider_claim_prefix}:sub"
    }

    condition {
      test = "StringEquals"
      values = var.additional_audiences != null ? concat(
        [format("sts.%v", data.aws_partition.this[0].dns_suffix)],
        var.additional_audiences,
      ) : [format("sts.%v", data.aws_partition.this[0].dns_suffix)]
      variable = "${local.oidc_provider_claim_prefix}:aud"
    }

    dynamic "condition" {
      for_each = var.additional_claim_conditions

      content {
        test     = trimspace(condition.value.test)
        values   = condition.value.values
        variable = "${local.oidc_provider_claim_prefix}:${trimspace(condition.value.claim)}"
      }
    }

    principals {
      identifiers = ["${local.oidc_provider_arn}%{if var.enterprise_slug != ""}/${var.enterprise_slug}%{endif}"]
      type        = "Federated"
    }
  }
}

data "aws_iam_openid_connect_provider" "github" {
  count = !local.create_oidc_provider ? 1 : 0

  url = local.oidc_provider_url
}

data "tls_certificate" "github" {
  count = local.create_oidc_provider ? 1 : 0

  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

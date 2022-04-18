data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      values   = var.match_value
      variable = "${aws_iam_openid_connect_provider.gitlab[0].url}:${var.match_field}"
    }

    principals {
      identifiers = [local.oidc_provider.arn]
      type        = "Federated"
    }
  }

  version = "2012-10-17"
}

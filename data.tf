data "aws_iam_policy_document" "github" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      values   = ["repo:${var.github_repository}:*"]
      variable = "token.actions.githubusercontent.com:sub:"
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.github.0.arn]
      type        = "Federated"
    }
  }
}

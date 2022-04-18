locals {
  oidc_provider = aws_iam_openid_connect_provider.gitlab[0]
  common_tags = {
    OIDC_Provider = "GitLab"
    ManagedBy     = "Terraform"
  }
}

resource "aws_iam_role" "gitlab" {
  count = var.enabled ? 1 : 0

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  description           = "Role used by the GitLab OIDC provider."
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  name                  = var.iam_role_name
  path                  = var.iam_role_path
  tags                  = local.common_tags
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = var.enabled && var.attach_admin_policy ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.gitlab[0].id
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.enabled ? length(var.aws_managed_policy_arns) : 0

  policy_arn = var.aws_managed_policy_arns[count.index]
  role       = aws_iam_role.gitlab[0].id
}

data "tls_certificate" "gitlab" {
  url = var.gitlab_url
}

resource "aws_iam_openid_connect_provider" "gitlab" {
  count = var.enabled && var.create_oidc_provider ? 1 : 0

  client_id_list = ["${var.audience}"]

  tags            = local.common_tags
  thumbprint_list = ["${data.tls_certificate.gitlab.certificates.0.sha1_fingerprint}"]
  url             = var.gitlab_url
}
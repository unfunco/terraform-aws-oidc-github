// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

locals {
  create_iam_role      = var.create && var.create_iam_role
  create_oidc_provider = var.create && var.create_oidc_provider

  attach_read_only_policy         = local.create_iam_role && var.attach_read_only_policy
  dangerously_attach_admin_policy = local.create_iam_role && var.dangerously_attach_admin_policy

  audience = format("sts.%v", local.dns_suffix)

  github_organizations = toset([
    for repo in var.github_repositories : split("/", repo)[0]
  ])

  dns_suffix = data.aws_partition.this.dns_suffix
  partition  = data.aws_partition.this.partition

  oidc_provider_arn = (
    var.create_oidc_provider ?
    aws_iam_openid_connect_provider.github[0].arn :
    data.aws_iam_openid_connect_provider.github[0].arn
  )
}

resource "aws_iam_role" "github" {
  count = local.create_iam_role ? 1 : 0

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  description           = "Assumed by the GitHub OIDC provider."
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  name                  = var.iam_role_name
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_role_permissions_boundary
  tags                  = var.tags
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = { for k, v in var.iam_role_inline_policies : k => v }

  name   = each.key
  policy = each.value
  role   = aws_iam_role.github[0].id
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = local.create_iam_role && var.dangerously_attach_admin_policy ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.github[0].id
}

resource "aws_iam_role_policy_attachment" "read_only" {
  count = local.create_iam_role && var.attach_read_only_policy ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.github[0].id
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = local.create_iam_role ? length(var.iam_role_policy_arns) : 0

  role = aws_iam_role.github[0].id
  policy_arn = format(
    "arn:%v:iam::aws:policy/AdministratorAccess",
    local.partition,
  )
}

resource "aws_iam_openid_connect_provider" "github" {
  count = local.create_oidc_provider ? 1 : 0

  client_id_list = concat(
    [for org in local.github_organizations : format("https://github.com/%v", org)],
    [local.audience],
  )

  tags = var.tags

  thumbprint_list = toset(
    concat(
      [data.tls_certificate.github[0].certificates[0].sha1_fingerprint],
      var.additional_thumbprints,
    )
  )

  url = format(
    "https://token.actions.githubusercontent.com%v",
    var.enterprise_slug != "" ? "/${var.enterprise_slug}" : "",
  )
}

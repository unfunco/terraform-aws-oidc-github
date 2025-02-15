// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

locals {
  audience = format("sts.%v", local.dns_suffix)
  github_organizations = toset([
    for repo in var.github_repositories : split("/", repo)[0]
  ])
  dns_suffix        = data.aws_partition.current.dns_suffix
  oidc_provider_arn = var.enabled ? (var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn) : ""
  partition         = data.aws_partition.current.partition
}

resource "aws_iam_role" "github" {
  count = var.enabled ? 1 : 0

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  description           = "Role assumed by the GitHub OIDC provider."
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  name                  = var.iam_role_name
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_role_permissions_boundary
  tags                  = var.tags

}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = { for k, v in var.iam_role_inline_policies : k => v if var.enabled }
  name     = each.key
  policy   = each.value
  role     = aws_iam_role.github[0].id
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = var.enabled && var.dangerously_attach_admin_policy ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.github[0].id
}

resource "aws_iam_role_policy_attachment" "read_only" {
  count = var.enabled && var.attach_read_only_policy ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.github[0].id
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.enabled ? length(var.iam_role_policy_arns) : 0

  policy_arn = var.iam_role_policy_arns[count.index]
  role       = aws_iam_role.github[0].id
}

resource "aws_iam_openid_connect_provider" "github" {
  count = var.enabled && var.create_oidc_provider ? 1 : 0

  client_id_list = concat(
    [for org in local.github_organizations : "https://github.com/${org}"],
    [local.audience],
  )

  tags = var.tags
  url  = "https://token.actions.githubusercontent.com%{if var.enterprise_slug != ""}/${var.enterprise_slug}%{endif}"
  thumbprint_list = toset(
    concat(
      [data.tls_certificate.github.certificates[0].sha1_fingerprint],
      var.additional_thumbprints,
    )
  )
}

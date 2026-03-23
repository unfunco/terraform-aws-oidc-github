// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

locals {
  create_iam_role = var.create && var.create_iam_role && (
    var.github_repositories != null && length(var.github_repositories) > 0
  )

  create_oidc_provider = var.create && var.create_oidc_provider && (
    var.github_repositories != null && length(var.github_repositories) > 0
  )

  custom_iam_role_policy_arns = local.create_iam_role ? toset([
    for policy_name in var.iam_role_policy_names :
    "arn:${data.aws_partition.this[0].partition}:iam::aws:policy/${policy_name}"
  ]) : toset([])

  dangerously_attach_admin_policy = local.create_iam_role && var.dangerously_attach_admin_policy

  github_organizations = toset([
    for repo in var.github_repositories : split("/", repo)[0]
  ])

  oidc_provider_path         = var.enterprise_slug != "" ? "/${var.enterprise_slug}" : ""
  oidc_provider_url          = "https://token.actions.githubusercontent.com${local.oidc_provider_path}"
  oidc_provider_claim_prefix = "token.actions.githubusercontent.com${local.oidc_provider_path}"

  oidc_provider_arn = (
    local.create_oidc_provider ?
    aws_iam_openid_connect_provider.github[0].arn :
    data.aws_iam_openid_connect_provider.github[0].arn
  )
}

resource "aws_iam_role" "github" {
  count = local.create_iam_role ? 1 : 0

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  description           = var.iam_role_description
  force_detach_policies = var.iam_role_force_detach_policies
  max_session_duration  = var.iam_role_max_session_duration
  name                  = var.iam_role_name
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_role_permissions_boundary
  tags                  = merge(var.tags, var.iam_role_tags)
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = { for k, v in var.iam_role_inline_policies : k => v }

  name   = each.key
  policy = each.value
  role   = aws_iam_role.github[0].id
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = local.create_iam_role && var.dangerously_attach_admin_policy ? 1 : 0

  policy_arn = "arn:${data.aws_partition.this[0].partition}:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.github[0].id
}

resource "aws_iam_role_policy_attachment" "custom" {
  for_each = local.custom_iam_role_policy_arns

  policy_arn = each.value
  role       = aws_iam_role.github[0].id
}

resource "aws_iam_openid_connect_provider" "github" {
  count = local.create_oidc_provider ? 1 : 0

  client_id_list = concat(
    [for org in local.github_organizations : format("https://github.com/%v", org)],
    [format("sts.%v", data.aws_partition.this[0].dns_suffix)],
  )

  tags = merge(var.tags, var.oidc_provider_tags)

  thumbprint_list = toset(
    concat(
      [data.tls_certificate.github[0].certificates[0].sha1_fingerprint],
      var.additional_thumbprints,
    )
  )

  url = local.oidc_provider_url
}

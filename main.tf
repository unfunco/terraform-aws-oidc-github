// Copyright © 2021 Daniel Morris
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

locals {
  github_organizations = toset([for repo in var.github_repositories : split("/", repo)[0]])
  oidc_provider_arn    = var.enabled ? (var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn) : ""
  partition            = data.aws_partition.current.partition
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

  dynamic "inline_policy" {
    for_each = var.iam_role_inline_policies

    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = var.enabled && var.attach_admin_policy ? 1 : 0

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
    ["sts.amazonaws.com"]
  )

  tags = var.tags
  url  = "https://token.actions.githubusercontent.com%{if var.enterprise_slug != ""}/${var.enterprise_slug}%{endif}"
  thumbprint_list = var.additional_thumbprints != null ? distinct(
    concat(
      [data.tls_certificate.github.certificates[0].sha1_fingerprint],
      [for thumbprint in var.additional_thumbprints : thumbprint]
    )
  ) : [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

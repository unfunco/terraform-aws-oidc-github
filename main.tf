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
  enabled = var.enabled ? 1 : 0

  // Refer to the README for information on obtaining the thumbprint.
  github_thumbprint = "a031c46782e6e6c662c2c87c76da9aa62ccabd8e"
}

resource "aws_iam_role" "github" {
  count = local.enabled

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  description           = "Role used by the ${var.github_organisation}/${var.github_repository} GitHub repository."
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  name                  = var.iam_role_name
  path                  = var.iam_role_path
  tags                  = var.tags
}

resource "aws_iam_role_policy" "github" {
  count = local.enabled

  name_prefix = var.iam_role_name
  policy      = data.aws_iam_policy_document.github[0].json
  role        = aws_iam_role.github[0].id
}

resource "aws_iam_openid_connect_provider" "github" {
  count = local.enabled

  client_id_list  = ["https://github.com/${var.github_organisation}", "sts.amazonaws.com"]
  tags            = var.tags
  thumbprint_list = [local.github_thumbprint]
  url             = "https://token.actions.githubusercontent.com"
}

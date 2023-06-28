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

variable "additional_thumbprints" {
  default     = null
  description = "List of additional thumbprints for the OIDC provider."
  type        = list(string)

  validation {
    condition     = var.additional_thumbprints == null ? true : length(var.additional_thumbprints) <= 3
    error_message = "Only 3 additional thumbprints can be set, for a maximum of 5 in the OIDC provider."
  }
}

variable "attach_admin_policy" {
  default     = false
  description = "Flag to enable/disable the attachment of the AdministratorAccess policy."
  type        = bool
}

variable "attach_read_only_policy" {
  default     = true
  description = "Flag to enable/disable the attachment of the ReadOnly policy."
  type        = bool
}

variable "create_oidc_provider" {
  default     = true
  description = "Flag to enable/disable the creation of the GitHub OIDC provider."
  type        = bool
}

variable "enabled" {
  default     = true
  description = "Flag to enable/disable the creation of resources."
  type        = bool
}

variable "enterprise_slug" {
  default     = ""
  description = "Enterprise slug for GitHub Enterprise Cloud customers."
  type        = string
}

variable "force_detach_policies" {
  default     = false
  description = "Flag to force detachment of policies attached to the IAM role."
  type        = bool
}

variable "github_repositories" {
  description = "List of GitHub organization/repository names authorized to assume the role."
  type        = list(string)

  validation {
    // Ensures each element of github_repositories list matches the
    // organization/repository format used by GitHub.
    condition = length([
      for repo in var.github_repositories : 1
      if length(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/-]+[*]?|\\*)$", repo)) > 0
    ]) == length(var.github_repositories)
    error_message = "Repositories must be specified in the organization/repository format."
  }
}

variable "iam_role_name" {
  default     = "github"
  description = "Name of the IAM role to be created. This will be assumable by GitHub."
  type        = string
}

variable "iam_role_path" {
  default     = "/"
  description = "Path under which to create IAM role."
  type        = string
}

variable "iam_role_permissions_boundary" {
  default     = ""
  description = "ARN of the permissions boundary to be used by the IAM role."
  type        = string
}

variable "iam_role_policy_arns" {
  default     = []
  description = "List of IAM policy ARNs to attach to the IAM role."
  type        = list(string)
}

variable "iam_role_inline_policies" {
  default     = {}
  description = "Inline policies map with policy name as key and json as value."
  type        = map(string)
}

variable "max_session_duration" {
  default     = 3600
  description = "Maximum session duration in seconds."
  type        = number

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Maximum session duration must be between 3600 and 43200 seconds."
  }
}

variable "tags" {
  default     = {}
  description = "Map of tags to be applied to all resources."
  type        = map(string)
}

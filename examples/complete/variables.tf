// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

variable "additional_audiences" {
  default     = null
  description = "List of additional OIDC audiences allowed to assume the role."
  type        = list(string)
}

variable "additional_thumbprints" {
  default     = []
  description = "A list of additional thumbprints for the OIDC provider."
  type        = list(string)

  validation {
    condition     = length(var.additional_thumbprints) <= 5
    error_message = "A maximum of 5 additional thumbprints can be configured in the OIDC provider."
  }
}

variable "attach_read_only_policy" {
  default     = false
  description = "Flag to enable/disable the attachment of the ReadOnly policy."
  type        = bool
}

variable "create_oidc_provider" {
  default     = true
  description = "Flag to enable/disable the creation of the GitHub OIDC provider."
  type        = bool
}

variable "dangerously_attach_admin_policy" {
  default     = false
  description = "Flag to enable/disable the attachment of the AdministratorAccess policy."
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
  description = "A list of GitHub organization/repository names authorized to assume the role."
  type        = list(string)

  validation {
    // Ensures each element of github_repositories list matches the
    // organization/repository format used by GitHub.
    condition = length([
      for repo in var.github_repositories : 1
      if length(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/\\-\\*]+)$", repo)) > 0
    ]) == length(var.github_repositories)
    error_message = "Repositories must be specified in the organization/repository format."
  }
}

variable "iam_role_name" {
  default     = "GitHubActions"
  description = "The name of the IAM role to be created and made assumable by GitHub Actions."
  type        = string
}

variable "iam_role_path" {
  default     = "/"
  description = "The path under which to create IAM role."
  type        = string
}

variable "iam_role_permissions_boundary" {
  default     = ""
  description = "The ARN of the permissions boundary to be used by the IAM role."
  type        = string
}

variable "iam_role_policy_arns" {
  default     = []
  description = "A list of IAM policy ARNs to attach to the IAM role."
  type        = list(string)
}

variable "iam_role_inline_policies" {
  default     = {}
  description = "Inline policies map with policy name as key and json as value."
  type        = map(string)
}

variable "max_session_duration" {
  default     = 3600
  description = "The maximum session duration in seconds."
  type        = number

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "The maximum session duration must be between 3600 and 43200 seconds."
  }
}

variable "tags" {
  default     = {}
  description = "A map of tags to be applied to all applicable resources."
  type        = map(string)
}

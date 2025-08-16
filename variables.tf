// SPDX-FileCopyrightText: 2024 Daniel Morris <daniel@honestempire.com>
// SPDX-License-Identifier: MIT

variable "additional_audiences" {
  default     = null
  description = "Additional OIDC audiences allowed to assume the role."
  type        = list(string)
}

variable "additional_thumbprints" {
  default     = []
  description = "Additional thumbprints for the OIDC provider."
  type        = list(string)

  validation {
    condition     = length(var.additional_thumbprints) <= 5
    error_message = "A maximum of 5 additional thumbprints can be configured in the OIDC provider."
  }
}

variable "attach_read_only_policy" {
  default     = false
  description = "Enable/disable the attachment of the ReadOnly policy."
  type        = bool
}

variable "create" {
  default     = true
  description = "Enable/disable the creation of all resources."
  type        = bool
}

variable "create_iam_role" {
  default     = true
  description = "Enable/disable creation of the IAM role."
  type        = bool
}

variable "create_oidc_provider" {
  default     = true
  description = "Enable/disable the creation of the GitHub OIDC provider."
  type        = bool
}

variable "dangerously_attach_admin_policy" {
  default     = false
  description = "Enable/disable the attachment of the AdministratorAccess policy."
  type        = bool
}

variable "enterprise_slug" {
  default     = ""
  description = "Enterprise slug for GitHub Enterprise Cloud customers."
  type        = string
}

variable "github_repositories" {
  default     = []
  description = "GitHub organization/repository names authorized to assume the role."
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

variable "iam_role_description" {
  default     = "Assumed by the GitHub OIDC provider."
  description = "Description of the IAM role to be created."
  type        = string
}

variable "iam_role_force_detach_policies" {
  default     = false
  description = "Force detachment of policies attached to the IAM role."
  type        = bool
}

variable "iam_role_max_session_duration" {
  default     = 3600
  description = "The maximum session duration in seconds."
  type        = number

  validation {
    condition     = var.iam_role_max_session_duration >= 3600 && var.iam_role_max_session_duration <= 43200
    error_message = "The maximum session duration must be between 3600 and 43200 seconds."
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
  description = "IAM policy ARNs to attach to the IAM role."
  type        = list(string)
}

variable "iam_role_inline_policies" {
  default     = {}
  description = "Inline policies map with policy name as key and json as value."
  type        = map(string)
}

variable "iam_role_tags" {
  default     = {}
  description = "Additional tags to be applied to the IAM role."
  type        = map(string)
}

variable "oidc_provider_tags" {
  default     = {}
  description = "Tags to be applied to the OIDC provider."
  type        = map(string)
}

variable "tags" {
  default     = {}
  description = "Tags to be applied to all applicable resources."
  type        = map(string)
}

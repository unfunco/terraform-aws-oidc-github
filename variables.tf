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

variable "default_subject" {
  default     = "ref:refs/heads/main"
  description = "Default GitHub OIDC subject pattern appended to github_subjects entries without an explicit subject suffix. Examples: ref:refs/heads/main, pull_request, *."
  type        = string

  validation {
    condition     = trimspace(var.default_subject) != "" && !startswith(trimspace(var.default_subject), ":")
    error_message = "The default subject must not be empty or start with ':'. Use values such as ref:refs/heads/main, pull_request, or *."
  }
}

variable "enterprise_slug" {
  default     = ""
  description = "Enterprise slug for GitHub Enterprise Cloud customers. This changes the OIDC issuer URL and IAM condition keys."
  type        = string
}

variable "github_subjects" {
  default     = []
  description = "GitHub repository subject patterns authorized to assume the role. Entries may be bare owner/repository values or include an explicit subject suffix such as :pull_request or :ref:refs/tags/v*."
  type        = list(string)

  validation {
    // Ensures each element of github_subjects matches a GitHub
    // owner/repository value with an optional explicit subject suffix.
    condition = length([
      for subject in var.github_subjects : 1
      if length(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/\\-\\*]+)$", subject)) > 0
    ]) == length(var.github_subjects)
    error_message = "Subjects must be specified as owner/repository, optionally followed by a subject suffix such as :pull_request or :ref:refs/heads/main."
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

variable "iam_role_policy_names" {
  default     = []
  description = "AWS managed IAM policy names to attach to the IAM role. Provide the value after `policy/`, for example `ReadOnlyAccess` or `service-role/AWSLambdaBasicExecutionRole`."
  type        = list(string)

  validation {
    condition = alltrue([
      for policy_name in var.iam_role_policy_names :
      trimspace(policy_name) != "" && !startswith(trimspace(policy_name), "arn:")
    ])
    error_message = "IAM role policies must be provided as AWS managed policy names, not full ARNs."
  }
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

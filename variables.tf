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

variable "gitlab_url" {
  type        = string
  description = "The address of your GitLab instance, such as https://gitlab.com or http://gitlab.example.com."

}

variable "audience" {
  type        = string
  description = "The address of your GitLab instance, such as https://gitlab.com or http://gitlab.example.com."

}

variable "force_detach_policies" {
  default     = false
  description = "Flag to force detachment of policies attached to the IAM role."
  type        = string
}

variable "max_session_duration" {
  default     = 3600
  description = "Maximum session duration in seconds."
  type        = number

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Maximum session duration must be between 1 and 12 hours."
  }
}

variable "iam_role_name" {
  default     = "gitlab_action_role"
  description = "Name of the IAM role to be created. This will be assumable by GitLab."
  type        = string
}

variable "iam_role_path" {
  default     = "/"
  description = "Path under which to create IAM role."
  type        = string
}

variable "aws_managed_policy_arns" {
  default     = []
  description = "List of AWS managed IAM policy ARNs to attach to the IAM role."
  type        = list(string)
}

variable "attach_admin_policy" {
  default     = false
  type        = bool
  description = "Flag to enable/disable the attachment of the AdministratorAccess policy."

}

variable "match_field" {
  type        = string
  default     = "aud"
  description = "	Issuer, the domain of your GitLab instance. Default 'aud'. Change to 'sub' if you want to use the filter to any project"
}

variable "match_value" {
  type        = list(any)
  description = "It should be the your Gitab Instance URl by default. But if you want to use filer to a specific group, branch or tag, use this format project_path:mygroup/myproject:ref_type:branch:ref:main"

}

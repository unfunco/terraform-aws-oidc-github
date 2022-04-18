variable "create_oidc_provider" {
  default     = true
  description = "Flag to enable/disable the creation of the GitHub OIDC provider."
  type        = bool
}

variable "attach_admin_policy" {
  default     = false
  type        = bool
  description = "Flag to enable/disable the attachment of the AdministratorAccess policy."

}

variable "aws_managed_policy_arns" {
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  description = "List of AWS managed IAM policy ARNs to attach to the IAM role."
  type        = list(any)
}

variable "gitlab_url" {
  type        = string
  default     = "https://gitlab.com"
  description = "The address of your GitLab instance, such as https://gitlab.com or http://gitlab.example.com."

}

variable "audience" {
  type        = string
  default     = "https://gitlab.com"
  description = "The address of your GitLab instance, such as https://gitlab.com or http://gitlab.example.com."

}

variable "match_field" {
  type        = string
  default     = "sub"
  description = "	Issuer, the domain of your GitLab instance. Default 'aud'. Change to 'sub' if you want to use the filter to a specific branch or group"
}

variable "match_value" {
  type        = list(any)
  default     = ["project_path:{group_id}/{project}:ref_type:branch:ref:main"]
  description = "It should be the your Gitab Instance URl by default. But if you want to use filer to a specific group, branch or tag, use this format project_path:mygroup/myproject:ref_type:branch:ref:main"

}

variable "aws_region" {
  type    = string
  default = "us-east-1"

}


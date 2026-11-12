variable "github_subjects" {
  description = "GitHub repository subject patterns authorized to assume the role."
  nullable    = false
  type        = list(string)

  validation {
    condition     = length(var.github_subjects) > 0
    error_message = "Provide at least one GitHub repository subject to create the managing role."
  }
}

variable "workload_account_id" {
  description = "The ID of the member account that GitHub Actions deploys into."
  type        = string
}

variable "workload_admin_role_name" {
  default     = "OrganizationAccountAccessRole"
  description = "The role Terraform assumes to manage resources in the member account."
  type        = string
}

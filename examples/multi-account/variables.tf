variable "github_subjects" {
  default     = []
  description = "GitHub repository subject patterns authorized to assume the role."
  type        = list(string)
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

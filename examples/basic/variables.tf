variable "github_repositories" {
  default     = []
  description = "GitHub organization/repository names authorized to assume the role."
  type        = list(string)
}

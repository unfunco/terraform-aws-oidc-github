variable "github_subjects" {
  default     = []
  description = "GitHub repository subject patterns authorized to assume the role."
  type        = list(string)
}

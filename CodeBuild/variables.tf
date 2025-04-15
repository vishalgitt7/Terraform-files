variable "github_repo_link" {
  type = string
  description = "https://github.com/vishalgitt7/first-repo"
}

variable "artifacts_type" {
  description = "Type of artifacts (supports: NO_ARTIFACTS or CODEPIPELINE)"
  default     = "NO_ARTIFACTS"
}
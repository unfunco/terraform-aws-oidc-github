provider "aws" {
  region = "eu-west-1"
}

run "single_github_repository_no_branch_specified" {
  variables {
    github_repositories = ["unfunco/terraform-aws-oidc-github"]
  }

  command = plan

  assert {
    condition     = aws_s3_bucket.bucket.bucket == "test-bucket"
    error_message = "S3 bucket name did not match expected"
  }
}

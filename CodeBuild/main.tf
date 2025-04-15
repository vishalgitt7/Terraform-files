provider "aws" {
  region = "us-east-1" # Update with your desired region
}

# Create IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

# Define IAM Policy for CodeBuild
resource "aws_iam_policy" "codebuild_policy" {
  name = "CodeBuildPolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetRepository",
        "codecommit:ListBranches",
        "codecommit:ListRepositories"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
EOF
}

# Define CodeBuild Project
resource "aws_codebuild_project" "example" {
  name         = "my-codebuild-project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = var.artifacts_type
  }

  source {
    type        = "GITHUB"
    location    = var.github_repo_link
  # auth_type    = "OAUTH" # Use OAuth for public repositories
    buildspec = "project-2048/2048-codes/buildspec.yml"
    # For private repositories, use a connection with secret access token
    # auth_type = "BASIC"
    # ... (basic auth configuration)
  }

  environment {
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    compute_type = "BUILD_GENERAL1_SMALL"
    type         = "LINUX_CONTAINER"
  }
}
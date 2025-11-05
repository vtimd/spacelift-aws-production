variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.region
  # Spacelift automatically injects credentials (assumed role) if you enable the AWS integration for this stack.
}

provider "random" {}

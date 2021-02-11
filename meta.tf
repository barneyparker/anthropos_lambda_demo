# Terraform & Provider Versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.2.0"
    }
  }

  backend "s3" {
    region = "eu-west-2" # default to eu-west-2 as our target region
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

variable "aws_region" {
  type        = string
  description = "Current AWS Region"
}

variable "envname" {
  type        = string
  description = "Environment Name"
}

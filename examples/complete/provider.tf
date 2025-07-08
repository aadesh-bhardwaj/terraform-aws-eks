provider "aws" {
  region = local.region
  default_tags {
    tags = local.additional_aws_tags
  }
  assume_role {
    role_arn    = var.role_arn
    external_id = var.external_id
    duration    = "30m"
  }
}

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.99.1"
    }
  }
}

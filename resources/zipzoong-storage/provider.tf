locals {
  service = "zipzoong"
  region  = "ap-northeast-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.3.0"
    }
  }
  backend "remote" {
    organization = local.service
    workspaces {
      name = "${local.service}-s3"
    }
  }
}

provider "aws" {
  region = local.region
  assume_role {
    role_arn     = var.assume_role_arn
    session_name = "terraform-storage"
  }
}


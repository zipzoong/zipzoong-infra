terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.3.0"
    }
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn     = var.admin_role_arn
    session_name = "terraform"
  }
}

module "vpc" {
  source  = "./resources/vpc"
  region  = var.region
  project = var.service
}

module "ecr_backend_main" {
  source  = "./resources/ecr"
  name    = "${var.service}_backend_main"
  kms_key = "${var.service}_production_kms"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.3.0"
    }
  }
  backend "remote" {
    organization = "zipzoong"
    workspaces {
      name = "zipzoong"
    }
  }
}

locals {
  service = "zipzoong"
  region  = "ap-northeast-2"
}

provider "aws" {
  region = local.region
  assume_role {
    role_arn     = var.assume_role_arn
    session_name = "terraform"
  }
}

module "s3_public" {
  source  = "./resources/s3"
  service = local.service
  bucket  = "public"
}

module "s3_private" {
  source  = "./resources/s3"
  service = local.service
  bucket  = "private"
}

module "s3_internal" {
  source  = "./resources/s3"
  service = local.service
  bucket  = "internal"
}

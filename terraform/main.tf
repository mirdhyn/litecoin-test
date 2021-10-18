module "iam" {
  source = "./iam"
  name = "prod-ci"
  account_id = "123456789012"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.34.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

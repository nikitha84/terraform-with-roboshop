terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.17.0"
    }
  }
  backend "s3" {
    bucket = "daws76-bucket"
    key    = "dev-database"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}

provider "aws" {
  region= "us-east-1"
}
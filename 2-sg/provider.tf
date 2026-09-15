terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.53.0"
    }
  }
 
  backend "s3" { #terraform aws s3 backend
    bucket         = "roboshop-remote-s3"
    key            = "sg-s3" #[like file name]
    region         = "us-east-1"
    encrypt        = true #Enable server side encryption of the state and lock files.
    use_lockfile = true #use a lockfile for locking the state file.
    
  }
}


provider "aws" {
  region         = "us-east-1"
}
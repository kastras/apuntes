terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "terraformkastras"
    key    = "network/terraform.tfstate"
    region = "eu-west-3"
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-3"
}


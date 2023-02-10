terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
    shared_credentials_files = ["C:/Users/$USER/.aws/credentials"]
    region = var.region
}
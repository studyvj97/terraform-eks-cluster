terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "mycompany-tf-state"          # <- change
    key            = "networking/terraform.tfstate"
    region         = "us-east-1"                  # <- change if needed
    dynamodb_table = "mycompany-tf-locks"         # <- change
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

locals {
  environment = terraform.workspace

  common_tags = {
    Environment = local.environment
    Project     = "platform-networking"
    ManagedBy   = "terraform"
  }
}


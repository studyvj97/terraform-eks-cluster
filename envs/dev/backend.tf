terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-97"
    key            = "eks/dev/terraform.tfstate"
    region         = "eu-north-1"          # 👈 IMPORTANT
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}


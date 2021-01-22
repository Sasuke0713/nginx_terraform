terraform {
  backend "s3" {
    bucket         = "sasuke-itachi-collab-terraform-states"
    key            = "global/sasuke-itachi-collab-terraform-states-s3-bucket.tfstate"
    encrypt        = "true"
    region         = "us-west-2"
    profile        = "sasuke-itachi-collab"
  }
}

provider "aws" {
  profile = "sasuke-itachi-collab"
  region = "us-west-2"
}
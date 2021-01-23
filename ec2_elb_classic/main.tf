
terraform {
  backend "s3" {
    bucket         = "sasuke-itachi-collab-terraform-states"
    key            = "test/us-west-2/ec2_elb_classic.tfstate"
    encrypt        = "true"
    region         = "us-west-2"
    profile        = "sasuke-itachi-collab"
  }
  required_version = "~> 0.13"
}

provider "aws" {
  profile = "sasuke-itachi-collab"
  region  = "us-west-2"
}

module "ec2_elb_classic" {
  source = "../modules/ec2_elb_classic"

  service                 = var.service
  webpage                 = var.webpage
  webserver_desired_size  = var.webserver_desired_size
  webserver_max_size      = var.webserver_max_size
  tags                    = merge(var.tags, { Environment = terraform.workspace })
}

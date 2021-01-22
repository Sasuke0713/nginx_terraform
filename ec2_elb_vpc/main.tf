
terraform {
  backend "s3" {
    bucket         = "sasuke-itachi-collab-terraform-states"
    key            = "test/us-west-2/ec2_elb_vpc.tfstate"
    encrypt        = "true"
    region         = "us-west-2"
    profile        = "sasuke-itachi-collab"
  }
}

provider "aws" {
  profile = "sasuke-itachi-collab"
  region  = "us-west-2"
}

module "vpc" {
  source = "../modules/vpc"

  aws_region                   = var.aws_region
  aws_availability_zones       = var.aws_availability_zones
  vpc_cidr                     = var.vpc_cidr
  vpc_name                     = "${terraform.workspace}-${var.vpc_name}"
  public_subnet_01_name        = "${terraform.workspace}-${var.public_subnet_01_name}"
  public_subnet_01_cidr_block  = var.public_subnet_01_cidr_block
  public_subnet_02_name        = "${terraform.workspace}-${var.public_subnet_02_name}"
  public_subnet_02_cidr_block  = var.public_subnet_02_cidr_block
  public_subnet_03_name        = "${terraform.workspace}-${var.public_subnet_03_name}"
  public_subnet_03_cidr_block  = var.public_subnet_03_cidr_block
  private_subnet_01_name       = "${terraform.workspace}-${var.private_subnet_01_name}"
  private_subnet_01_cidr_block = var.private_subnet_01_cidr_block
  private_subnet_02_name       = "${terraform.workspace}-${var.private_subnet_02_name}"
  private_subnet_02_cidr_block = var.private_subnet_02_cidr_block
  private_subnet_03_name       = "${terraform.workspace}-${var.private_subnet_03_name}"
  private_subnet_03_cidr_block = var.private_subnet_03_cidr_block
  tags                         = merge(var.tags, { Environment = terraform.workspace })
}

module "ec2_elb_vpc" {
  source = "../modules/ec2_elb_vpc"

  service                 = var.service
  webpage                 = var.webpage
  webserver_desired_size  = var.webserver_desired_size
  webserver_max_size      = var.webserver_max_size
  tags                    = merge(var.tags, { Environment = terraform.workspace })
  vpc_id                  = module.vpc.vpc_id
  vpc_public_subnet_ids   = module.vpc.vpc_public_subnet_ids
  vpc_private_subnet_ids  = module.vpc.vpc_private_subnet_ids
}

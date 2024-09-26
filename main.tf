provider "aws" {
  region = "us-east-1"
}

# Call VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

# Call ALB Module
module "alb" {
  source = "./modules/alb"

  vpc_id     = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
}

# Call EC2 Module
module "ec2" {
  source = "./modules/ec2"

  vpc_id     = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  alb_sg_id  = module.alb.alb_sg_id
}

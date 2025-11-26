locals {
  project_id = "${var.project_name}-${var.environment}"
}

module "vpc" {
  source               = "./modules/VPC"
  project_name         = local.project_id
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnets       = var.public_subnet_cidrs
  private_subnets      = var.private_subnet_cidrs
  azs                  = var.azs
  create_nat_per_az    = var.create_nat_per_az
}

module "ec2" {
  source          = "./modules/ec2"
  project_name    = local.project_id
  public_subnets  = module.vpc.public_subnets

  ami             = var.instance_ami
  instance_type   = var.instance_type

  min_size        = var.min_size
  max_size        = var.max_size
  desired_capacity = var.desired_capacity

  security_group_ids = var.instance_security_groups
}

module "rds" {
  source                 = "./modules/rds"
  project_name           = local.project_id
  allocated_storage      = var.allocated_storage
  instance_class         = var.instance_class
  db_engine              = var.db_engine
  db_username            = var.db_username
  db_password            = var.db_password
  private_subnets        = module.vpc.private_subnets
  vpc_security_group_ids = var.vpc_security_group_ids
}
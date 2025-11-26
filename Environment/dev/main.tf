module "vpc" {
  source               = "../../modules/VPC"

  project_name         = var.project_name
  aws_region           = var.aws_region

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs

  create_nat_per_az    = var.create_nat_per_az
}

module "ec2" {
  source               = "../../modules/ec2"

  project_name         = var.project_name
  instance_ami         = var.instance_ami
  instance_type        = var.instance_type

  public_subnets       = module.vpc.public_subnets
# ASG Required Variables
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity

  # ASG/EC2 SG
  security_group_ids   = var.instance_security_groups
}

module "rds" {
  source                 = "../../modules/rds"

  project_name           = var.project_name
  db_identifier          = var.db_identifier
  db_username            = var.db_username
  db_password            = var.db_password

  instance_class         = var.instance_class
  db_engine              = var.db_engine
  allocated_storage      = var.allocated_storage

  private_subnets        = module.vpc.private_subnets
  vpc_security_group_ids = var.vpc_security_group_ids
}
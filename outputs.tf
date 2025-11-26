output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "asg_name" {
  value = module.ec2.asg_name
}

output "rds_primary" {
  value = module.rds.primary_endpoint
}

output "rds_replica" {
  value = module.rds.replica_endpoint
}
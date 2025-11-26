project_name      = "myproject-prod"
aws_region   = "ap-south-1"

project_name = "myproject-prod"

environment = "prod"

vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.2.0/24"
]

private_subnet_cidrs = [
  "10.10.3.0/24",
  "10.10.4.0/24"
]

create_nat_per_az = true

# Availability zones for subnets (adjust to your region)
azs = ["ap-south-1a", "ap-south-1b"]

# EC2
instance_ami    = "ami-02b8269d5e85954ef"
instance_type   = "t3.medium"
min_size        = 2
max_size        = 5
desired_capacity = 2
instance_security_groups = []

# RDS
db_identifier     = "mydb-prod"
db_username       = "admin"
db_password       = "StrongProdPassword!@#"

instance_class    = "db.t3.small"
db_engine         = "mysql"
allocated_storage = 20

vpc_security_group_ids = []
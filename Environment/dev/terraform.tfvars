project_name = "myproject-dev"
aws_region   = "ap-south-1"

# Environment and scaling/settings
environment = "dev"
desired_capacity = 2
instance_security_groups = []

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

create_nat_per_az = true

# Availability zones for subnets (adjust to your region)
azs = ["ap-south-1a", "ap-south-1b"]

# EC2
instance_ami    = "ami-02b8269d5e85954ef"
instance_type   = "t3.micro"
min_size        = 2
max_size        = 5

# RDS
db_identifier     = "mydb-dev"
db_username       = "admin"
db_password       = "DevPass123!"

instance_class    = "db.t3.micro"
db_engine         = "mysql"
allocated_storage = 20

vpc_security_group_ids = ["sg-0123456789abcdef0"]
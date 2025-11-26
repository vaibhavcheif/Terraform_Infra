variable "project_name" {}
variable "environment" {}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "create_nat_per_az" {
  type = bool
}

variable "instance_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "instance_security_groups" {
  type = list(string)
}

variable "allocated_storage" {
  type = number
}

variable "instance_class" {
  type = string
}

variable "db_engine" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}
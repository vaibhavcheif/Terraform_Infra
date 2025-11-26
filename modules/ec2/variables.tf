variable "project_name" {
	type = string
}

variable "instance_ami" {
	type    = string
	default = ""
}

variable "instance_type" {
	type = string
}

variable "public_subnets" {
	type = list(string)
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

variable "security_group_ids" {
	type = list(string)
}

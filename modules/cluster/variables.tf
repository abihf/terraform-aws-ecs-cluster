variable "cluster_name" {
  description = "The name of your cluster"
  type        = "string"
}

variable "environment" {
  description = "An environment tag in which your service will deployed and executed, i.e. staging, production, etc."
  type        = "string"
  default     = "staging"
}

variable "product_domain" {
  description = "Product domain name for tagging"
  type        = "string"
  default     = ""
}

variable "ec2_ami" {
  description = "AMI that used by launch configuration"
  type        = "string"
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type within your cluster"
  type        = "string"
  default     = "t2.medium"
}

variable "min_size" {
  description = "Minimum number of running ECS container instances"
  type        = "string"
  default     = "1"
}

variable "max_size" {
  description = "Maximum number of running ECS container instances"
  type        = "string"
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = "string"
}

variable "instance_sg" {
  description = "Additional security group for ECS container instances"
  type        = "list"
  default     = []
}

variable "vpc_id" {
  description = "The id of the VPC that the desired security group belongs to"
  type        = "string"
}

variable "subnets" {
  description = "A list of subnet IDs to launch resources in"
  type        = "list"
}

variable "log_retention" {
  description = "number of days to retain log events in cloudwatch"
  type        = "string"
  default     = 14
}

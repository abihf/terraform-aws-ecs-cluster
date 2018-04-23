variable "asg_name" {
  description = "The name of autoscaling group"
  type        = "string"
}

variable "cluster_name" {
  description = "The name of your cluster"
  type        = "string"
}

variable "environment" {
  description = "An environment tag in which your service will deployed and executed, i.e. staging, production, etc."
  type        = "string"
}

variable "product_domain" {
  description = "Product domain name for tagging"
  type        = "string"
}

variable "log_retention" {
  description = "number of days to retain log events in cloudwatch"
  type        = "string"
  default     = 14
}

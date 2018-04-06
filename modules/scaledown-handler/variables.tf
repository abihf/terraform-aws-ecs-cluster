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
  default     = "staging"
}

variable "product_domain" {
  description = "Product domain name for tagging"
  default     = ""
}

variable "log_retention" {
  default     = 14
  description = "number of days to retain log events in cloudwatch"
}

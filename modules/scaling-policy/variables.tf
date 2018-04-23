variable "cluster_name" {
  description = "The name of your cluster"
  type        = "string"
}

variable "asg_name" {
  description = "The name of autoscaling group"
  type        = "string"
}

variable "scaling_target_cpu_reservation" {
  description = "Average CPU reservation metric for scaling policy"
  type        = "string"
  default     = 75
}

variable "scaling_target_memory_reservation" {
  description = "Average Memory reservation metric for scaling policy"
  type        = "string"
  default     = 75
}

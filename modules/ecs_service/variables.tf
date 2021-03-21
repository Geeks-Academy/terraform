### MANDATORY
variable "account_number" {
  description = "AWS account number."
  type        = string
}

variable "service_name" {
  description = "Name of the service."
  type        = string
}

variable "ecs_role_name" {
  description = "Role name for services/tasks."
  type        = string
}

variable "cluster_name" {
  description = "Name of ECS cluster."
  type        = string
}

variable "container_port" {
  description = "Port exposed by container."
  type        = number
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}


### OPTIONAL
variable "name_prefix" {
  description = "Name prefix."
  type        = string
  default     = "ga-"
}

variable "region" {
  description = "AWS region name."
  type        = string
  default     = "eu-central-1"
}

variable "image" {
  description = "Docker image URI."
  type        = string
  default     = "nginx:latest"
}

variable "desired_count" {
  description = "Count of tasks."
  type        = string
  default     = "1"
}

variable "deployment_minimum_healthy_percent" {
  description = "How many tasks in percentage must be always healthy."
  type        = string
  default     = "0"
}

variable "cpu" {
  description = "How many cpu to be reserved."
  type        = number
  default     = 10
}

variable "memoryReservation" {
  description = "How many memory to be reserved."
  type        = number
  default     = 128
}

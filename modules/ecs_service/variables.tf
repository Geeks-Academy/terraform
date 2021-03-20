### MANDATORY
variable "account_number" {
  description = "AWS account number."
  type        = string
}

variable "service_name" {
  description = "Name of the service."
  type        = string
}

variable "task_def_file_path" {
  description = "Path to file where Task Definition JSON file is."
  type        = string
}

variable "ecs_role_arn" {
  description = "Role ARN for services/tasks."
  type        = string
}

variable "cluster_name" {
  description = "Name of ECS cluster."
  type        = string
}

variable "container_port" {
  description = "Port exposed by container."
  type        = string
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
variable "region" {
  description = "AWS region name."
  type        = string
  default     = "eu-central-1"
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

variable "name_prefix" {
  description = "Name prefix."
  type        = string
  default     = "ga-"
}
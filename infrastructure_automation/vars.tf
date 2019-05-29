variable "env" {
  description = "The name of the environment"
}

variable "region" {
  description = "The name of the region"
}

variable "deregistration_delay" {
  default     = "300"
  description = "The default deregistration delay"
}

variable "health_check_path" {
  default     = "/"
  description = "The default health check path"
}

variable "key_pair_name" {
  description = "The name of the region"
}

variable "instance_type" {
  description = "instance type"
}


variable "tag" {
  default = "latest"
  description = "Docker tag"
}


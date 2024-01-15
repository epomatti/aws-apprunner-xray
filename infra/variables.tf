variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "app_runner_workload" {
  type    = string
  default = "NONE"
}

variable "create_app_runner" {
  type = bool
}

variable "app_runner_cpu" {
  type    = string
  default = "1 vCPU"
}

variable "app_runner_memory" {
  type    = string
  default = "2 GB"
}

variable "ecr_image_tag" {
  type = string
}

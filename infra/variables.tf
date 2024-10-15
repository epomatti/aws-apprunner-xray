variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "app_runner_workload" {
  type = string
}

variable "create_app_runner" {
  type = bool
}

variable "create_xray_sampling_rule" {
  type = bool
}

variable "app_runner_cpu" {
  type = string
}

variable "app_runner_memory" {
  type = string
}

variable "ecr_image_tag" {
  type = string
}

variable "xray_debug_mode" {
  type = string
}

variable "enable_dockerfile_otel_agent" {
  type = bool
}

variable "enable_apprunner_observability" {
  type = bool
}

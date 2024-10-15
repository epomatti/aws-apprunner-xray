variable "workload" {
  type = string
}

variable "cpu" {
  type = string
}

variable "mem" {
  type = string
}

variable "instance_role_arn" {
  type = string
}

variable "access_role_arn" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "image_tag" {
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

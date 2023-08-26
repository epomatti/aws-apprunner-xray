variable "workload" {
  type = string
}

variable "subnet" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "route_tables" {
  type = list(string)
}

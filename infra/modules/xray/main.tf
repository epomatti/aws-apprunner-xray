resource "aws_xray_sampling_rule" "default" {
  rule_name      = "JavaApp"
  priority       = 100
  version        = 1
  reservoir_size = 1
  fixed_rate     = 1
  url_path       = "*"
  # url_path       = "/api/*"
  host           = "*"
  # host           = var.host
  http_method    = "*"
  service_type   = "*"
  # service_name   = "MyApp"
  service_name   = "*"
  resource_arn   = "*"
}

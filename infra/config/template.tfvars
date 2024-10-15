# Resources
create_app_runner         = true
create_xray_sampling_rule = false

# Observability
enable_dockerfile_otel_agent   = true
enable_apprunner_observability = true
xray_logging_level             = "INFO"
otel_javaagent_debug           = "false"

# App Runner
app_runner_workload = "PUBLIC"  # PUPLIC, PUBLIC_WITH_VPC
ecr_image_tag       = "javaapp" # latest, javaapp
app_runner_cpu      = "2 vCPU"
app_runner_memory   = "4 GB"
xray_debug_mode     = "TRUE"

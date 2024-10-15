create_app_runner         = false
create_xray_sampling_rule = false

# Observability
enable_dockerfile_otel_agent   = true
enable_apprunner_observability = true

app_runner_workload = "PUBLIC"  # PUPLIC, PUBLIC_WITH_VPC
ecr_image_tag       = "javaapp" # latest, javaapp

app_runner_cpu    = "4 vCPU"
app_runner_memory = "8 GB"

xray_debug_mode = "TRUE"

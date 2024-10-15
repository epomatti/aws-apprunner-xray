terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.71.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  create_public_apprunner_count          = var.app_runner_workload == "PUBLIC" && var.create_app_runner == true ? 1 : 0
  create_public_with_vpc_apprunner_count = var.app_runner_workload == "PUBLIC_WITH_VPC" && var.create_app_runner == true ? 1 : 0
}

resource "aws_ecr_repository" "app" {
  name                 = "apprunner-xray"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

module "iam" {
  source = "./modules/iam"
}

module "apprunner_public" {
  source            = "./modules/public"
  count             = local.create_public_apprunner_count
  workload          = "public"
  cpu               = var.app_runner_cpu
  mem               = var.app_runner_memory
  instance_role_arn = module.iam.instance_role_arn
  access_role_arn   = module.iam.access_role_arn
  repository_url    = aws_ecr_repository.app.repository_url
  image_tag         = var.ecr_image_tag
  xray_debug_mode   = var.xray_debug_mode
}

module "apprunner_private" {
  source            = "./modules/private"
  count             = local.create_public_with_vpc_apprunner_count
  aws_region        = var.aws_region
  workload          = "private"
  cpu               = var.app_runner_cpu
  mem               = var.app_runner_memory
  instance_role_arn = module.iam.instance_role_arn
  access_role_arn   = module.iam.access_role_arn
  repository_url    = aws_ecr_repository.app.repository_url
  image_tag         = var.ecr_image_tag
  xray_debug_mode   = var.xray_debug_mode
}

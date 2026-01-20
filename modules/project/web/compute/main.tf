terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "ecs_cluster" {
  source = "../../../common/aws/compute/ecs/cluster"

  name = "${var.project_name}-web"
}

module "ecs_task_definition" {
  source = "../../../common/aws/compute/ecs/task_definition"

  name                    = "${var.project_name}-web"
  task_cpu                = "256"
  task_memory             = "512"
  task_execution_role_arn = var.task_execution_role_arn
  task_role_arn           = var.task_role_arn
  container_name          = "web"
  service_image           = var.service_image
  container_port          = 80
  host_port               = 80
  aws_region              = var.aws_region
  health_check_command    = ["CMD-SHELL", "curl -f http://localhost:80 || exit 1"]
  log_retention_days      = 3
}

module "ecs_service" {
  source = "../../../common/aws/compute/ecs/ec2"

  name                  = "${var.project_name}-web"
  ami_id                = ""
  instance_type         = var.instance_type
  instance_profile_name = var.instance_profile_name
  security_group_id     = var.security_group_id
  use_spot              = var.use_spot
  asg_max               = 2
  asg_min               = 1
  desired_count         = 1
  subnet_ids            = var.subnet_ids
  ecs_cluster_id        = module.ecs_cluster.id
  ecs_cluster_name      = module.ecs_cluster.name
  task_definition_arn   = module.ecs_task_definition.arn
  alb_target_group_arn  = var.alb_target_group_arn
  container_name        = "web"
  container_port        = 80
}

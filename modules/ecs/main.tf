# ECS Module - Defines ECS Cluster, Task Definition, and Service

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ECS Cluster (shared by all services)
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

# CloudWatch Log Group for each service
resource "aws_cloudwatch_log_group" "this" {
  for_each = var.services

  name              = "/ecs/${var.project_name}/${each.key}"
  retention_in_days = each.value.log_retention_days

  tags = {
    Name    = "${var.project_name}-${each.key}-logs"
    Service = each.key
  }
}

# ECS Task Definition for each service (EC2 launch type)
resource "aws_ecs_task_definition" "this" {
  for_each = var.services

  family                   = "${var.project_name}-${each.key}"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = each.value.task_cpu
  memory                   = each.value.task_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = each.value.container_name
      image     = var.service_images[each.key]
      essential = true

      portMappings = [
        {
          containerPort = each.value.container_port
          hostPort      = each.value.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        for key, value in each.value.environment_variables : {
          name  = key
          value = value
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this[each.key].name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      healthCheck = each.value.health_check_command != null ? {
        command     = each.value.health_check_command
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      } : null
    }
  ])

  tags = {
    Name    = "${var.project_name}-${each.key}-task"
    Service = each.key
  }
}

# Get recommended ECS-optimized AMI for Amazon Linux 2
data "aws_ssm_parameter" "this" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

# Launch template for ECS instances
resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-ecs-"
  image_id      = coalesce(var.ecs_ami_id, data.aws_ssm_parameter.this.value)
  instance_type = var.ecs_instance_type

  iam_instance_profile {
    name = var.ecs_instance_profile_name
  }

  network_interfaces {
    security_groups = [var.ecs_security_group_id]
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config
EOF
  )
}

# Auto Scaling Group for ECS container instances
resource "aws_autoscaling_group" "this" {
  desired_capacity    = var.ecs_desired_capacity
  max_size            = var.ecs_asg_max
  min_size            = var.ecs_asg_min
  vpc_zone_identifier = var.subnet_ids
  protect_from_scale_in = true

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ecs-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ECS Capacity Provider backed by the ASG
resource "aws_ecs_capacity_provider" "this" {
  name = "${var.project_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.this.arn

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 75
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1000
    }

    managed_termination_protection = "ENABLED"
  }
}

# Attach capacity provider to cluster as default
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    weight            = 1
    base              = 0
  }
}

# ECS Service for each service
resource "aws_ecs_service" "this" {
  for_each = var.services

  name            = "${var.project_name}-${each.key}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this[each.key].arn
  desired_count   = each.value.desired_count

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    weight            = 1
    base              = 0
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  health_check_grace_period_seconds = lookup(var.alb_target_group_arns, each.key, null) != null ? each.value.health_check_grace_period : null

  # Register with ALB target group if ALB is enabled
  dynamic "load_balancer" {
    for_each = lookup(var.alb_target_group_arns, each.key, null) != null ? [1] : []
    content {
      target_group_arn = var.alb_target_group_arns[each.key]
      container_name   = each.value.container_name
      container_port   = each.value.container_port
    }
  }

  tags = {
    Name    = "${var.project_name}-${each.key}-service"
    Service = each.key
  }
}

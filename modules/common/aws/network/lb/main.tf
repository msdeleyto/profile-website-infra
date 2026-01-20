terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection       = false
  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_lb_target_group" "this" {
  for_each = var.services

  name        = "${var.name}-${each.key}-tg"
  port        = each.value.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = var.target_type

  # Health check configuration
  health_check {
    enabled             = true
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
    timeout             = each.value.health_check_timeout
    interval            = each.value.health_check_interval
    path                = each.value.health_check_path
    matcher             = each.value.health_check_matcher
    protocol            = "HTTP"
  }

  # Deregistration delay
  deregistration_delay = each.value.deregistration_delay

  tags = {
    Name    = "${var.name}-${each.key}-tg"
    Service = each.key
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "https" {
  count = 1

  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  # Default action
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Service not found"
      status_code  = "404"
    }
  }

  tags = {
    Name = "${var.name}-https-listener"
  }
}

resource "aws_lb_listener" "http_redirect" {
  count = 1

  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name = "${var.name}-http-redirect-listener"
  }
}

resource "aws_lb_listener_rule" "this" {
  for_each = var.services

  # Use HTTPS listener if certificate provided, otherwise HTTP direct listener
  listener_arn = aws_lb_listener.https[0].arn
  priority     = each.value.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  # Route based on path pattern or host header
  dynamic "condition" {
    for_each = each.value.path_pattern != null ? [1] : []
    content {
      path_pattern {
        values = [each.value.path_pattern]
      }
    }
  }

  dynamic "condition" {
    for_each = each.value.host_header != null ? [1] : []
    content {
      host_header {
        values = [each.value.host_header]
      }
    }
  }

  tags = {
    Name    = "${var.name}-${each.key}-rule"
    Service = each.key
  }
}

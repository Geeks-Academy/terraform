### ALB
resource "aws_alb" "this" {
  name                       = var.name
  internal                   = var.internal
  security_groups            = var.security_groups
  subnets                    = var.subnets
  idle_timeout               = var.idle_timeout
  enable_http2               = var.http2_enabled
  enable_deletion_protection = var.deletion_protection_enabled

  tags = var.tags
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener_rule" "this" {
  for_each = { for target in var.target_groups : target.hostname => target }

  listener_arn = aws_alb_listener.this.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = each.value.target_group
  }

  condition {
    host_header {
      values = [each.value.hostname]
    }
  }
}

resource "aws_alb_listener" "this_ssl" {
  load_balancer_arn = aws_alb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_certificate" "this" {
  for_each        = toset(var.certificate_arns)
  listener_arn    = aws_alb_listener.this_ssl.arn
  certificate_arn = each.key
}

resource "aws_alb_listener_rule" "this_ssl" {
  count = var.create_ssl ? length(var.ssl_target_groups) : 0

  listener_arn = aws_alb_listener.this_ssl.arn
  priority     = lookup(var.ssl_target_groups[count.index], "priority", null)

  dynamic "action" {
    for_each = [
      for action_rule in var.ssl_target_groups[count.index].actions :
      action_rule
      if action_rule.type == "forward"
    ]

    content {
      type             = action.value["type"]
      target_group_arn = action.value["target_group"]
    }
  }

  dynamic "condition" {
    for_each = [
      for condition_rule in var.ssl_target_groups[count.index].conditions :
      condition_rule
      if length(lookup(condition_rule, "hostname", [])) > 0
    ]

    content {
      host_header {
        values = condition.value["hostname"]
      }
    }
  }

  dynamic "condition" {
    for_each = [
      for condition_rule in var.ssl_target_groups[count.index].conditions :
      condition_rule
      if length(lookup(condition_rule, "path", [])) > 0
    ]

    content {
      path_pattern {
        values = condition.value["path"]
      }
    }
  }
}

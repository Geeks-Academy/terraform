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

resource "aws_alb_listener" "this_only_ssl" {
  count = var.if_only_ssl ? 1 : 0

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


resource "aws_alb_listener" "this" {
  count = var.if_only_ssl ? 0 : 1

  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
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

resource "aws_lb_listener_rule" "this_ssl" {
  for_each = var.target_group

  listener_arn = aws_alb_listener.this_ssl.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = each.arn
  }

  condition {
    host_header {
      values = [each.hostname]
    }
  }
}

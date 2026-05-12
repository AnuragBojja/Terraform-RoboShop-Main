resource "aws_lb" "frontend-alb" {
  name               = "${local.common_name}-frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.frontend_alb_sg_id]
  subnets            = local.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-backend-alb"
    }
    
  )
}

resource "aws_lb_listener" "frontend-alb" {
  load_balancer_arn = aws_lb.frontend-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  certificate_arn   = local.frontend_alb_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi! This is frontend from alb<h1>"
      status_code  = "200"
    }
  }
}
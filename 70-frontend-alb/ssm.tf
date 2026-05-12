resource "aws_ssm_parameter" "frontend_alb_listener_arn" {
  name  = "/${var.project_name}/${var.env}/frontend_alb_listener_arn"
  type  = "StringList"
  value = aws_lb_listener.frontend-alb.arn
}
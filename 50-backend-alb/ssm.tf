resource "aws_ssm_parameter" "backend_alb_listener_arn" {
  name  = "/${var.project_name}/${var.env}/backend_alb_listener_arn"
  type  = "StringList"
  value = local.backend_alb_listener_arn
}
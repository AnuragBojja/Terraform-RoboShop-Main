locals {
  common_tags = {
    Project_name = var.project_name
    Env = var.env
    Terraform = "true"
  }
  common_name = ("${var.project_name}-${var.env}")
  frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
  public_subnet_ids = split(",",data.aws_ssm_parameter.public_subnet_ids.value)

  frontend_alb_certificate_arn = data.aws_ssm_parameter.frontend_alb_certificate_arn.value

  zone_id = data.aws_route53_zone.zone.id
}
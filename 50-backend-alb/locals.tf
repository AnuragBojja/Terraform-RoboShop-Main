locals {
  common_tags = {
    Project_name = var.project_name
    Env = var.env
    Terraform = "true"
  }
  common_name = ("${var.project_name}-${var.env}")
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value
  private_subnet_ids = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  backend_alb_listener_arn = aws_lb_listener.backend-alb.arn
#   bastion_sg_id = data.aws_ssm_parameter.sg_id_bastion.value
#   ami_id = data.aws_ami.roboshop_ami.id
}
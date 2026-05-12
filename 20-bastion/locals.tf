locals {
  common_tags = {
    Project_name = var.project_name
    Env = var.env
    Terraform = "true"
  }
  common_name = ("${var.project_name}-${var.env}")
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
  ami_id = data.aws_ami.roboshop_ami.id
  public_subnet_id = split(",",data.aws_ssm_parameter.public_subnet_ids.value)[0]
}
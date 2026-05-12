data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.env}/vpc_id"
}
####### ALB #####
data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/${var.project_name}/${var.env}/backend_alb_sg_id"
}
data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/${var.project_name}/${var.env}/frontend_alb_sg_id"
}

########## Bastion #####
data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project_name}/${var.env}/bastion_sg_id"
}

#### DATABASES ###
data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project_name}/${var.env}/mongodb_sg_id"
}
data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project_name}/${var.env}/redis_sg_id"
}
data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project_name}/${var.env}/rabbitmq_sg_id"
}
data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project_name}/${var.env}/mysql_sg_id"
}

#### BACKEND ####
data "aws_ssm_parameter" "cart_sg_id" {
  name = "/${var.project_name}/${var.env}/cart_sg_id"
}
data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project_name}/${var.env}/catalogue_sg_id"
}
data "aws_ssm_parameter" "user_sg_id" {
  name = "/${var.project_name}/${var.env}/user_sg_id"
}
data "aws_ssm_parameter" "payment_sg_id" {
  name = "/${var.project_name}/${var.env}/payment_sg_id"
}
data "aws_ssm_parameter" "shipping_sg_id" {
  name = "/${var.project_name}/${var.env}/shipping_sg_id"
}

#### SUBNETS ####
data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project_name}/${var.env}/database_subnet_ids"
}
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.env}/public_subnet_ids"
}
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.env}/private_subnet_ids"
}

##### frontend ######
data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project_name}/${var.env}/frontend_sg_id"
}

################# OPENVPN #############
data "aws_ssm_parameter" "openvpn_sg_id" {
  name = "/${var.project_name}/${var.env}/openvpn_sg_id"
}
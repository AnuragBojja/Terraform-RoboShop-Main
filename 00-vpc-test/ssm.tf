resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.env}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}
resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.env}/public_subnet_ids"
  type  = "StringList"
  value = local.public_subnet_ids
}
resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.env}/private_subnet_ids"
  type  = "StringList"
  value = local.private_subnet_ids
}
resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project_name}/${var.env}/database_subnet_ids"
  type  = "StringList"
  value = local.database_subnet_ids
}
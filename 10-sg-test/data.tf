data "aws_ssm_parameter" "vpc_id" {
  name = "/roboshop/dev/vpc_id"
}
#bastion allowing laptop to connect 
resource "aws_security_group_rule" "bastion-laptop" {
  type              = "ingress"
  security_group_id = local.bastion_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
################# ALB ##################
#backend_alb allowing bastion to connect 
resource "aws_security_group_rule" "backend_alb-bastion" {
  type              = "ingress"
  security_group_id = local.backend_alb_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}
resource "aws_security_group_rule" "frontend_alb-bastion" {
  type              = "ingress"
  security_group_id = local.frontend_alb_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}
######################### DATABASES ALLOWING BASTION ###############
#mongodb allowing bastion to connect 
resource "aws_security_group_rule" "mongodb-bastion" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
#rabbitmq allowing  bastion to connect 
resource "aws_security_group_rule" "rabbitmq-bastion" {
  type              = "ingress"
  security_group_id = local.rabbitmq_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
#redis allowing  bastion to connect 
resource "aws_security_group_rule" "redis-bastion" {
  type              = "ingress"
  security_group_id = local.redis_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
#mysql allowing  bastion to connect 
resource "aws_security_group_rule" "mysql-bastion" {
  type              = "ingress"
  security_group_id = local.mysql_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

######################### BACKEND ALLOWING BASTION #####################
#catalogue allowing bastion to connect 
resource "aws_security_group_rule" "catalogue-bastion" {
  type              = "ingress"
  security_group_id = local.catalogue_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
resource "aws_security_group_rule" "user-bastion" {
  type              = "ingress"
  security_group_id = local.user_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
resource "aws_security_group_rule" "cart-bastion" {
  type              = "ingress"
  security_group_id = local.cart_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
resource "aws_security_group_rule" "payment-bastion" {
  type              = "ingress"
  security_group_id = local.payment_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
resource "aws_security_group_rule" "shipping-bastion" {
  type              = "ingress"
  security_group_id = local.shipping_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
######### frontend allowing bastion ############
resource "aws_security_group_rule" "frontend-bastion" {
  type              = "ingress"
  security_group_id = local.frontend_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
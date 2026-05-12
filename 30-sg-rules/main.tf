
######################## CATALOGUE ################
#mongodb allowing catalogue to connect 
resource "aws_security_group_rule" "mongodb-catalogue" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id
  source_security_group_id = local.catalogue_sg_id
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
}
#catalogue allowing backend_alb
resource "aws_security_group_rule" "catalogue-backend_alb" {
  type              = "ingress"
  security_group_id = local.catalogue_sg_id
  source_security_group_id = local.backend_alb_sg_id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
}
######################  USER  ########################
resource "aws_security_group_rule" "user-backend_alb" {
  type              = "ingress"
  security_group_id = local.user_sg_id
  source_security_group_id = local.backend_alb_sg_id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
}

resource "aws_security_group_rule" "redis-user" {
  type              = "ingress"
  security_group_id = local.redis_sg_id
  source_security_group_id = local.user_sg_id
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
}
resource "aws_security_group_rule" "mongodb-user" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id
  source_security_group_id = local.user_sg_id
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
}
#######################  CART  ############################
resource "aws_security_group_rule" "cart-backend_alb" {
  type              = "ingress"
  security_group_id = local.cart_sg_id
  source_security_group_id = local.backend_alb_sg_id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
}
resource "aws_security_group_rule" "redis-cart" {
  type              = "ingress"
  security_group_id = local.redis_sg_id
  source_security_group_id = local.cart_sg_id
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
}
############### PAYMENT ##################
resource "aws_security_group_rule" "payment-backend_alb" {
  type              = "ingress"
  security_group_id = local.payment_sg_id
  source_security_group_id = local.backend_alb_sg_id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
}
resource "aws_security_group_rule" "rabbitmq-payment" {
  type              = "ingress"
  security_group_id = local.rabbitmq_sg_id
  source_security_group_id = local.payment_sg_id
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
}
######### SHIPPING ###############
resource "aws_security_group_rule" "shipping-backend_alb" {
  type              = "ingress"
  security_group_id = local.shipping_sg_id
  source_security_group_id = local.backend_alb_sg_id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
}
resource "aws_security_group_rule" "mysql-shipping" {
  type              = "ingress"
  security_group_id = local.mysql_sg_id
  source_security_group_id = local.shipping_sg_id
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
}
################## frontend ##########
resource "aws_security_group_rule" "frontend-frontend_alb" {
  type              = "ingress"
  security_group_id = local.frontend_sg_id
  source_security_group_id = local.frontend_alb_sg_id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}


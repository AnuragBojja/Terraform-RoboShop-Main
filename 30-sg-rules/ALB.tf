############ Backend ALB ##########
resource "aws_security_group_rule" "backend_alb-frontend" {
  type              = "ingress"
  security_group_id = local.backend_alb_sg_id
  source_security_group_id = local.frontend_sg_id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}
resource "aws_security_group_rule" "backend_alb-cart" {
  type              = "ingress"
  security_group_id = local.backend_alb_sg_id
  source_security_group_id = local.cart_sg_id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}
resource "aws_security_group_rule" "backend_alb-shipping" {
  type              = "ingress"
  security_group_id = local.backend_alb_sg_id
  source_security_group_id = local.shipping_sg_id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}
resource "aws_security_group_rule" "backend_alb-payment" {
  type              = "ingress"
  security_group_id = local.backend_alb_sg_id
  source_security_group_id = local.payment_sg_id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}
################# frontend alb allowing from inter net ###########
resource "aws_security_group_rule" "frontend_alb-internet" {
  type              = "ingress"
  security_group_id = local.frontend_alb_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

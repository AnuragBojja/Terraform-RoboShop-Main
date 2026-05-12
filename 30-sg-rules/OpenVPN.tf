################# openvpn  from internet ###########
resource "aws_security_group_rule" "openvpn-ports" {
  for_each = var.openvpn-ports
  type              = "ingress"
  security_group_id = local.openvpn_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
}
################# openvpn ssh to services  ###########
resource "aws_security_group_rule" "openvpn-services" {
  for_each = local.vpn_ingress_rules_22
  type              = "ingress"
  security_group_id = each.value.sg_id
  source_security_group_id = local.openvpn_sg_id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}
#################### openvpn accessing 8080 port on servers #############
resource "aws_security_group_rule" "openvpn-server" {
  for_each = local.vpn_ingress_rules_8080
  type              = "ingress"
  security_group_id = each.value.sg_id
  source_security_group_id = local.openvpn_sg_id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
}
######################## openvpn accessing 80 port on alb ############
resource "aws_security_group_rule" "openvpn-alb" {
  for_each = local.vpn_ingress_rules_80
  type              = "ingress"
  security_group_id = each.value.sg_id
  source_security_group_id = local.openvpn_sg_id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}
################ openvpn accessing databases ##################
resource "aws_security_group_rule" "openvpn-databases" {
  for_each = local.vpn_ingress_rules_databases
  type              = "ingress"
  security_group_id = each.value.sg_id
  source_security_group_id = local.openvpn_sg_id
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
}
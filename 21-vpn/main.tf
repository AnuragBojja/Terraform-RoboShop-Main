resource "aws_instance" "OpenVPN" {
  ami           = local.openvpn_ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [local.openvpn_sg_id]
  subnet_id = local.public_subnet_id
  user_data = file("./openvpn.sh")
  # iam_instance_profile = aws_iam_instance_profile.Bastion-AdminAccess.name
  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-OpenVPN"
    }
  )
}

resource "aws_route53_record" "openvpn" {
  zone_id = local.zone_id
  name    = "openvpn-${var.env}.${var.domain_name}"
  type    = "A"
  ttl     = "1"
  records = [aws_instance.OpenVPN.public_ip]
}

resource "aws_route53_record" "backend-alb" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "*.backend-alb-${var.env}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.backend-alb.dns_name
    zone_id                = aws_lb.backend-alb.zone_id
    evaluate_target_health = true
  }
}
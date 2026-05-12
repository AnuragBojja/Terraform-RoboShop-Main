resource "aws_route53_record" "frontend-alb" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "roboshop-${var.env}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.frontend-alb.dns_name
    zone_id                = aws_lb.frontend-alb.zone_id
    evaluate_target_health = true
  }
}
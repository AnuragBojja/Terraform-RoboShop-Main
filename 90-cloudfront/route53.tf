resource "aws_route53_record" "cdn" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "${var.env}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.roboshop.domain_name
    zone_id                = aws_cloudfront_distribution.roboshop.hosted_zone_id
    evaluate_target_health = true
  }
}
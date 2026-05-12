data "aws_cloudfront_cache_policy" "CachingOptimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "CachingDisable" {
  name = "Managed-CachingDisabled"
}
data "aws_ssm_parameter" "certificate_arn" {
  name = "/${var.project_name}/${var.env}/frontend_alb_certificate_arn"
}
data "aws_route53_zone" "zone" {
  name         = "anuragaws.shop"
}
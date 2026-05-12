locals {
  common_tags = {
    Project_name = var.project_name
    Env = var.env
    Terraform = "true"
  }
  common_name = ("${var.project_name}-${var.env}")
  CachingOptimized = data.aws_cloudfront_cache_policy.CachingOptimized.id
  CachingDisable = data.aws_cloudfront_cache_policy.CachingDisable.id
  certificate_arn = data.aws_ssm_parameter.certificate_arn.value
  zone_id = data.aws_route53_zone.zone.id
}
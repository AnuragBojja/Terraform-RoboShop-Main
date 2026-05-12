resource "aws_cloudfront_distribution" "roboshop" {
  origin {
    domain_name              = "${var.project_name}-${var.env}.${var.domain_name}"
    origin_id                = "${var.project_name}-${var.env}.${var.domain_name}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  enabled             = true

  aliases = ["${var.env}.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project_name}-${var.env}.${var.domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = local.CachingDisable
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project_name}-${var.env}.${var.domain_name}"

    cache_policy_id = local.CachingOptimized
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project_name}-${var.env}.${var.domain_name}"

    cache_policy_id = local.CachingOptimized
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-backend-alb"
    }
    
  )

  viewer_certificate {
    acm_certificate_arn = local.certificate_arn
    ssl_support_method  = "sni-only"
  }
}


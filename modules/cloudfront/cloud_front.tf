resource "aws_cloudfront_distribution" "app_distribution" {
  origin {
    domain_name = var.alb_dns_name
    origin_id   = "alb_origin"
  }

  enabled = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "alb_origin"
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["CN"]  # Block traffic from China etc and other countries you want to blacklist
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

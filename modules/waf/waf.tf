resource "aws_wafv2_web_acl" "cloudfront_waf" {
  name        = "cloudfront-waf"
  description = "WAF for CloudFront"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "GeoBlockRule"
    priority = 1

    action {
      block {}
    }

    statement {
      and_statement {
        statement {
          geo_match_statement {
            country_codes = ["CN"]
          }
        }
        # use to stof sql injections
        statement {
          sqli_match_statement {
            field_to_match {
              body {}
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
          }
        }
        # Cross-site scripting (XSS) detection: Block requests that appear to contain XSS attacks:

        statement {
          xss_match_statement {
            field_to_match {
              body {}
            }
            text_transformation {
              priority = 1
              type     = "NONE"
            }
          }
        }
        #Rate-based rule: Block IP addresses that make too many requests in a 5-minute period:

      
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "GeoBlockRule"
    }
  }

  rule {
    name     = "RateLimitRule"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["CN"] # add the countries specific rate limiting you can use 
          }
        }
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cloudfront-waf"
    sampled_requests_enabled   = true
  }
}

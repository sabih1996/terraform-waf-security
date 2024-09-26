output "waf_arn" {
  value = aws_wafv2_web_acl.cloudfront_waf.arn
}

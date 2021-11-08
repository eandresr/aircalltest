output "arn" {
  description = "Amazon Resource Name (ARN) of the WAF ACL"
  value       = aws_wafv2_web_acl.waf.arn
}
output "id" {
  description = "ID  of the WAF ACL"
  value       = aws_wafv2_web_acl.waf.arn
}
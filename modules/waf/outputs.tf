output "web_acl_id" {
  description = "WAF Web ACL ID"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.main.arn
}

output "ip_set_arn" {
  description = "IP Set ARN (if enabled)"
  value       = var.ip_whitelist_enabled ? aws_wafv2_ip_set.whitelist[0].arn : null
}
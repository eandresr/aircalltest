output "cf_id" {
  value       = try(aws_cloudfront_distribution.cloudfrontdistribution.id, "")
  description = "ID of CloudFront distribution"
}

output "cf_arn" {
  value       = try(aws_cloudfront_distribution.cloudfrontdistribution.arn, "")
  description = "ARN of CloudFront distribution"
}


output "cf_status" {
  value       = try(aws_cloudfront_distribution.cloudfrontdistribution.status, "")
  description = "Current status of the distribution"
}

output "cf_domain_name" {
  value       = try(aws_cloudfront_distribution.cloudfrontdistribution.domain_name, "")
  description = "Domain name corresponding to the distribution"
}

output "cf_etag" {
  value       = try(aws_cloudfront_distribution.cloudfrontdistribution.etag, "")
  description = "Current version of the distribution's information"
}

output "cf_hosted_zone_id" {
  value       = try(aws_cloudfront_distribution.cloudfrontdistribution.hosted_zone_id, "")
  description = "CloudFront Route 53 Zone ID"
}

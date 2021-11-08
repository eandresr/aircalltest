output "id" {
  description = "The ID of the bucket"
  value       = aws_s3_bucket.bucket.id
}
output "arn" {
  description = "Amazon Resource Name (ARN) of the bucket"
  value       = aws_s3_bucket.bucket.arn
}
output "bucket_regional_domain_name" {
  description = "Amazon Resource Name (ARN) of the bucket"
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
}

output "cloudfront_access_identity_path" {
  value       = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
  description = "ID of CloudFront distribution"
}

output "oai_iam_arn" {
  value       = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
  description = "ID of CloudFront distribution"
}

output "oai_id" {
  value       = aws_cloudfront_origin_access_identity.origin_access_identity.id
  description = "ID of CloudFront distribution"
}
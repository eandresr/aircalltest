output "id" {
  description = "The ID of the bucket"
  value       = aws_s3_bucket.bucket.id
}
output "arn" {
  description = "Amazon Resource Name (ARN) of the bucket"
  value       = aws_s3_bucket.bucket.arn
}
output "bucket" {
  description = "Amazon Resource Name (ARN) of the bucket"
  value       = aws_s3_bucket.bucket.bucket
}

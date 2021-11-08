output "id" {
  description = "The ID of the repository"
  value       = aws_codepipeline.codepipeline.id
}
output "arn" {
  description = "Amazon Resource Name (ARN) of the repository"
  value       = aws_codepipeline.codepipeline.arn
}
output "SNSTopic" {
  description = "Pipeline approval topic"
  value       = aws_sns_topic.user_approval.arn
}
output "SNSSubscribers" {
  description = "Approvers"
  value       = join(";", local.emails)
}
output "id" {
  description = "Name (if imported via name) or ARN (if created via Terraform or imported via ARN) of the CodeBuild project"
  value       = aws_codebuild_project.default.id
}

output "arn" {
  description = "ARN of the CodeBuild project"
  value       = aws_codebuild_project.default.arn
}

output "name" {
  description = "ARN of the CodeBuild project"
  value       = aws_codebuild_project.default.name
}
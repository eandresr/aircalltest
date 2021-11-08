output "id" {
  description = "The ID of the repository"
  value       = aws_codecommit_repository.code_repo.id
}
output "arn" {
  description = "Amazon Resource Name (ARN) of the repository"
  value       = aws_codecommit_repository.code_repo.arn
}
output "clone_url_http" {
  description = "The URL to use for cloning the repository over HTTPS."
  value       = aws_codecommit_repository.code_repo.clone_url_http
}
output "default_branch" {
  description = "The URL to use for cloning the repository over HTTPS."
  value       = "master"
}
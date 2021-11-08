output "arn" {
  description = "Amazon Resource Name (ARN) of the repository"
  value       = aws_lambda_function.main.arn
}
output "invoke_arn" {
  description = "The URL to use for cloning the repository over HTTPS."
  value       = aws_lambda_function.main.invoke_arn
}
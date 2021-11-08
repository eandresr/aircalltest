output "invoke_url" {
  description = "The URL to invoke the API pointing to the stage, e.g., https://z4675bid1j.execute-api.eu-west-2.amazonaws.com/prod"
  value       = aws_api_gateway_stage.main.invoke_url
}
output "path_main" {
  description = "The path created"
  value       = var.path_main
}

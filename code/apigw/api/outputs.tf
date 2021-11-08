output "execution_arn" {
  description = "The execution ARN part to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function, e.g., arn:aws:execute-api:eu-west-2:123456789012:z4675bid1j, which can be concatenated with allowed stage, method and resource path."
  value       = aws_api_gateway_rest_api.apigw_api.execution_arn
}
output "arn" {
  description = "Amazon Resource Name (ARN)"
  value       = aws_api_gateway_rest_api.apigw_api.arn
}
output "id" {
  description = "The ID of the REST API"
  value       = aws_api_gateway_rest_api.apigw_api.id
}
output "root_resource_id" {
  description = "The ID of the Root Resource"
  value       = aws_api_gateway_rest_api.apigw_api.root_resource_id
}

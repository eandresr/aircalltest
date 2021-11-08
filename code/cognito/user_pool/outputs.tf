# TODO: Values needed for Azure AD Application definition according to this
# https://www.terminalbytes.com/azure-ad-integration-as-an-idp-with-aws-cognito/
output "CognitoUserPoolId" {
  description = "Cognito User Pool Id"
  value       = aws_cognito_user_pool.pool.id
}
output "CognitoUserPoolARN" {
  value = aws_cognito_identity_pool.main.arn
}
# A little bit ugly and strange but I prefer to be DRY my friend ...
locals {
  CognitoUserPoolDomainURL = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${local.region}.amazoncognito.com"
}
# TODO: Additional values needed to interact with OAuth2 endpoints directly  ...

output "CognitoUserPoolDomainURL" {
  description = "Cognito User Pool Domain URL "
  value       = local.CognitoUserPoolDomainURL
}

output "URN" {
  value = "urn:amazon:cognito:sp:${aws_cognito_user_pool.pool.id}"
}


output "CognitoUserPoolName" {
  description = "Cognito User Pool Name"
  value       = aws_cognito_user_pool.pool.name
}


output "identity_pool_id" {
  value = aws_cognito_identity_pool.main.id
}
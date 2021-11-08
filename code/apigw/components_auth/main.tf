resource "random_string" "suffix" {
  length    = 6
  min_lower = 6
  special   = false
}


####### LAMBDA ########

resource "aws_api_gateway_resource" "apigwbase" {
  rest_api_id = data.terraform_remote_state.apigw[0].outputs.id
  parent_id   = data.terraform_remote_state.apigw[0].outputs.root_resource_id
  path_part   = var.path_base
}
resource "aws_api_gateway_resource" "apigw" {
  rest_api_id = data.terraform_remote_state.apigw[0].outputs.id
  parent_id   = aws_api_gateway_resource.apigwbase.id
  path_part   = var.path_main
}

resource "aws_api_gateway_authorizer" "this" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = data.terraform_remote_state.apigw[0].outputs.id
  provider_arns = ["arn:aws:cognito-idp:${local.region}:${data.aws_caller_identity.current.account_id}:userpool/${data.terraform_remote_state.cognito[0].outputs.CognitoUserPoolId}"] #arn:aws:cognito-idp:{region}:{account_id}:userpool/{user_pool_id}
}
resource "aws_api_gateway_method" "apigwupload" {
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.apigw.id
  rest_api_id   = data.terraform_remote_state.apigw[0].outputs.id
}

resource "aws_api_gateway_method_response" "apigwupload" {
  rest_api_id = data.terraform_remote_state.apigw[0].outputs.id
  resource_id = aws_api_gateway_resource.apigw.id
  http_method = aws_api_gateway_method.apigwupload.http_method

  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "apigwupload" {
  http_method             = aws_api_gateway_method.apigwupload.http_method
  resource_id             = aws_api_gateway_resource.apigw.id
  rest_api_id             = data.terraform_remote_state.apigw[0].outputs.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.terraform_remote_state.lambdaupload[0].outputs.invoke_arn
}

resource "aws_api_gateway_deployment" "apigwupload" {
  rest_api_id = data.terraform_remote_state.apigw[0].outputs.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.apigw.id,
      aws_api_gateway_method.apigwupload.id,
      aws_api_gateway_integration.apigwupload.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}




############ MONITORING ###########

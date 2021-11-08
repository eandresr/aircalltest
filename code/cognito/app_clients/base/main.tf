resource "aws_cognito_user_pool_client" "client" {
  count                                = length(local.aws_cognito_user_pool_clients)
  name                                 = local.aws_cognito_user_pool_clients[count.index].name
  user_pool_id                         = data.terraform_remote_state.userpool[0].outputs.CognitoUserPoolId
  generate_secret                      = local.aws_cognito_user_pool_clients[count.index].generate_secret
  access_token_validity                = local.aws_cognito_user_pool_clients[count.index].access_token_validity
  allowed_oauth_flows                  = local.aws_cognito_user_pool_clients[count.index].allowed_oauth_flows
  allowed_oauth_flows_user_pool_client = local.aws_cognito_user_pool_clients[count.index].allowed_oauth_flows_user_pool_client
  allowed_oauth_scopes                 = local.aws_cognito_user_pool_clients[count.index].allowed_oauth_scopes
  callback_urls                        = local.aws_cognito_user_pool_clients[count.index].callback_urls
  explicit_auth_flows                  = local.aws_cognito_user_pool_clients[count.index].explicit_auth_flows
  id_token_validity                    = local.aws_cognito_user_pool_clients[count.index].id_token_validity
  enable_token_revocation              = local.aws_cognito_user_pool_clients[count.index].enable_token_revocation
  logout_urls                          = local.aws_cognito_user_pool_clients[count.index].logout_urls
  prevent_user_existence_errors        = local.aws_cognito_user_pool_clients[count.index].prevent_user_existence_errors
  #read_attributes                      = local.aws_cognito_user_pool_clients[count.index].read_attributes
  supported_identity_providers = local.aws_cognito_user_pool_clients[count.index].supported_identity_providers
  #write_attributes                     = local.aws_cognito_user_pool_clients[count.index].write_attributes
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}


############ OPTIONAL FOR THIS TEST ############

data "template_file" "index" {
  template = file("./files/index.html")
  vars = {
    CloudFrontDomain = data.terraform_remote_state.front[0].outputs.cf_domain_name
    ClientID         = aws_cognito_user_pool_client.client.0.id
    Domain           = data.terraform_remote_state.userpool[0].outputs.CognitoUserPoolDomainURL
  }
}
data "template_file" "callback" {
  template = file("./files/callback.html")
  vars = {
    CloudFrontDomain = data.terraform_remote_state.front[0].outputs.cf_domain_name
    ClientID         = aws_cognito_user_pool_client.client.0.id
    Domain           = data.terraform_remote_state.userpool[0].outputs.CognitoUserPoolDomainURL
  }
}
data "template_file" "user" {
  template = file("./files/user.html")
  vars = {
    CloudFrontDomain = data.terraform_remote_state.front[0].outputs.cf_domain_name
    ClientID         = aws_cognito_user_pool_client.client.0.id
    Domain           = data.terraform_remote_state.userpool[0].outputs.CognitoUserPoolDomainURL
  }
}


resource "aws_s3_bucket_object" "index" {
  bucket       = data.terraform_remote_state.bucket[0].outputs.id
  key          = "index.html"
  content      = data.template_file.index.rendered
  content_type = "text/html"
}
resource "aws_s3_bucket_object" "callback" {
  bucket       = data.terraform_remote_state.bucket[0].outputs.id
  key          = "callback.html"
  content      = data.template_file.callback.rendered
  content_type = "text/html"
}
resource "aws_s3_bucket_object" "user" {
  bucket       = data.terraform_remote_state.bucket[0].outputs.id
  key          = "user.html"
  content      = data.template_file.user.rendered
  content_type = "text/html"
}



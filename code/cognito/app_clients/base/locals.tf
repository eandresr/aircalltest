#  Las constantes que podemos utilizar en el despliegue de recursos, por ejemplo la region y el profile principal que usuarremos en el proveedor.
# Ej

locals {
  region  = var.region != "" ? var.region : "eu-west-1"
  profile = var.profile != "" ? var.profile : "terraform"



  #######NAMING#######
  cloud       = var.cloud
  project     = var.project
  env         = var.env
  service     = var.service
  naming_base = join("-", [local.cloud, local.project, local.env, local.service])



  aws_cognito_user_pool_clients = [
    {
      name                  = local.naming_base
      access_token_validity = 60
      allowed_oauth_flows = [
        "implicit",
      ]
      generate_secret                      = true
      allowed_oauth_flows_user_pool_client = true
      allowed_oauth_scopes = [
        # "email",
        # "openid",
        # "phone",
        # "profile",
        "aws.cognito.signin.user.admin",
      ]
      callback_urls = [
        "https://${data.terraform_remote_state.front[0].outputs.cf_domain_name}/callback.html",
      ]
      explicit_auth_flows = [
        "ALLOW_CUSTOM_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_SRP_AUTH",
      ]
      id_token_validity       = 60
      enable_token_revocation = false
      logout_urls = [
        "https://${data.terraform_remote_state.front[0].outputs.cf_domain_name}/callback.html",
      ]
      prevent_user_existence_errors = "ENABLED"
      read_attributes = [
        "address", "birthdate", "custom:groups", "email", "email_verified", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"
      ]
      supported_identity_providers = [
        "COGNITO"
      ]
      write_attributes = [
        "address", "birthdate", "custom:groups", "email", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo",
      ]
      token_validity_units = {
        access_token  = "minutes"
        id_token      = "minutes"
        refresh_token = "days"
      }
    }
  ]
}
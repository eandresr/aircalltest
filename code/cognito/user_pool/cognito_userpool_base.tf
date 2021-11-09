resource "aws_cognito_user_pool" "pool" {
  name                     = "aircall_userpool_test"
  auto_verified_attributes = []
  # Triggers executing lambdas


  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
  dynamic "schema" {
    for_each = local.attributes
    content {
      attribute_data_type      = schema.value["attribute_data_type"]
      developer_only_attribute = schema.value["developer_only_attribute"]
      mutable                  = schema.value["mutable"]
      name                     = schema.value["name"]
      required                 = schema.value["required"]

      string_attribute_constraints {
        max_length = schema.value["max_length"]
        min_length = schema.value["min_length"]
      }
    }
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = local.cognito_domain
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_ui_customization" "user_pool_ui_customization" {
  # Refer to the aws_cognito_user_pool_domain resource's
  # user_pool_id attribute to ensure it is in an 'Active' state
  user_pool_id = aws_cognito_user_pool_domain.main.user_pool_id

  # I know this is ugly, but it works we could find something more sophisticated in the future if needed
  # I got the content of this field by doing something like this :
  # aws cognito-idp get-ui-customization --user-pool-id "eu-west-1_ULO7grq6M" --profile terraform
  css        = ".logo-customizable {\n\tmax-width: 60%;\n\tmax-height: 30%;\n}\n.banner-customizable {\n\tpadding: 25px 0px 25px 0px;\n\tbackground-color: white;\n}\n.label-customizable {\n\tfont-weight: 400;\n}\n.textDescription-customizable {\n\tpadding-top: 10px;\n\tpadding-bottom: 10px;\n\tdisplay: block;\n\tfont-size: 16px;\n}\n.idpDescription-customizable {\n\tpadding-top: 10px;\n\tpadding-bottom: 10px;\n\tdisplay: block;\n\tfont-size: 16px;\n}\n.legalText-customizable {\n\tcolor: #747474;\n\tfont-size: 11px;\n}\n.submitButton-customizable {\n\tfont-size: 14px;\n\tfont-weight: bold;\n\tmargin: 20px 0px 10px 0px;\n\theight: 40px;\n\twidth: 100%;\n\tcolor: #fff;\n\tbackground-color: #D73937;\n}\n.submitButton-customizable:hover {\n\tcolor: #fff;\n\tbackground-color: #F44336;\n}\n.errorMessage-customizable {\n\tpadding: 5px;\n\tfont-size: 14px;\n\twidth: 100%;\n\tbackground: #F5F5F5;\n\tborder: 2px solid #D64958;\n\tcolor: #D64958;\n}\n.inputField-customizable {\n\twidth: 100%;\n\theight: 34px;\n\tcolor: #555;\n\tbackground-color: #fff;\n\tborder: 1px solid #ccc;\n}\n.inputField-customizable:focus {\n\tborder-color: #66afe9;\n\toutline: 0;\n}\n.idpButton-customizable {\n\theight: 40px;\n\twidth: 100%;\n\twidth: 100%;\n\ttext-align: center;\n\tmargin-bottom: 15px;\n\tcolor: #fff;\n\tbackground-color: #D73937;\n\tborder-color: #D32F2F;\n}\n.idpButton-customizable:hover {\n\tcolor: #fff;\n\tbackground-color: #F44336;\n}\n.socialButton-customizable {\n\tborder-radius: 2px;\n\theight: 40px;\n\tmargin-bottom: 15px;\n\tpadding: 1px;\n\ttext-align: left;\n\twidth: 100%;\n}\n.redirect-customizable {\n\ttext-align: center;\n}\n.passwordCheck-notValid-customizable {\n\tcolor: #DF3312;\n}\n.passwordCheck-valid-customizable {\n\tcolor: #19BF00;\n}\n.background-customizable {\n\tbackground-color: #fff;\n}\n"
  image_file = filebase64("include/aircall-logo.png")
}


resource "aws_cognito_identity_pool" "main" {
  identity_pool_name = local.naming_base
  # cognito_identity_providers {
  #   client_id               = split("_", aws_cognito_user_pool.pool.id)[1]
  #   provider_name           = aws_cognito_user_pool.pool.name
  #   server_side_token_check = false
  # }
}

resource "random_string" "suffix" {
  length    = 6
  min_lower = 6
  special   = false
}


####### LAMBDA ########

resource "aws_api_gateway_rest_api" "apigw_api" {
  name        = local.apgw_name
  description = "Generic API GW"
}

############ MONITORING ###########

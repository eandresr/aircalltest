data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "apigw" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/apigw/api/${var.env}/terraform.tfstate"
  }
}

data "terraform_remote_state" "lambdaupload" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/lambda/upload/${var.env}/terraform.tfstate"
  }
}

data "terraform_remote_state" "cognito" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/cognito/user_pool/${var.env}/terraform.tfstate"
  }
}
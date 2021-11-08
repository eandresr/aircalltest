data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "front" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/cloudfront/${var.env}/terraform.tfstate"
  }
}
data "terraform_remote_state" "bucket" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/s3/front/${var.env}/terraform.tfstate"
  }
}





data "terraform_remote_state" "userpool" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/cognito/user_pool/${var.env}/terraform.tfstate"
  }
}
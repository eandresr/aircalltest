data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "s3bucket" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/s3/images/${var.env}/terraform.tfstate"
  }
}

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

data "terraform_remote_state" "apigwcomp" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/apigw/components/${var.env}/terraform.tfstate"
  }
}
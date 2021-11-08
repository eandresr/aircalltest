data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "s3bucket" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/s3/cicd/${var.env}/terraform.tfstate"
  }
}
data "terraform_remote_state" "codebuild" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/cicd/codebuild/${var.env}/terraform.tfstate"
  }
}
data "terraform_remote_state" "codecommit" {
  count   = 1
  backend = "s3"
  config = {
    profile = local.profile
    region  = local.region
    bucket  = var.statebucket
    key     = "aircalltest/cicd/codecommit/${var.env}/terraform.tfstate"
  }
}
locals {
  region  = var.region != "" ? var.region : "eu-west-1"
  profile = var.profile != "" ? var.profile : "default"



  #######NAMING#######
  cloud                 = var.cloud
  project               = var.project
  env                   = var.env
  service               = var.service
  naming_base           = join("-", [local.cloud, local.project, local.env, local.service])
  codebuild_name        = "${local.naming_base}-codebuild-project"
  cloudwatch_group_name = "/aws/lambda/${local.codebuild_name}"
  cache                 = {}
}


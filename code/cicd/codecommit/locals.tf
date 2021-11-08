locals {
  region  = var.region != "" ? var.region : "eu-west-1"
  profile = var.profile != "" ? var.profile : "default"



  #######NAMING#######
  cloud       = var.cloud
  project     = var.project
  env         = var.env
  service     = var.service
  naming_base = join("-", [local.cloud, local.project, local.env, local.service])
  repo_name   = var.repo_name != "" ? var.repo_name : join("-", [local.naming_base, "codecommit", random_string.suffix.result])
}


locals {
  region  = var.region != "" ? var.region : "eu-west-1"
  profile = var.profile != "" ? var.profile : "default"



  #######NAMING#######
  cloud         = var.cloud
  project       = var.project
  env           = var.env
  service       = var.service
  naming_base   = join("-", [local.cloud, local.project, local.env, local.service])
  function_name = var.function_name != "" ? var.function_name : join("-", [local.naming_base, random_string.suffix.result])
}


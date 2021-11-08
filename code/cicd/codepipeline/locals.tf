locals {
  region  = var.region != "" ? var.region : "eu-west-1"
  profile = var.profile != "" ? var.profile : "default"



  #######NAMING#######
  cloud         = var.cloud
  project       = var.project
  env           = var.env
  service       = var.service
  naming_base   = join("-", [local.cloud, local.project, local.env, local.service])
  pipeline_name = var.pipeline_name != "" ? var.pipeline_name : join("-", [local.naming_base, "codepipeline", random_string.suffix.result])
  topic_name    = join("-", [local.naming_base, "pipelinetopic", random_string.suffix.result])
  emails        = ["eduardo.andres.rabano@gmail.com"]
}


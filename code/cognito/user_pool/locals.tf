#  Las constantes que podemos utilizar en el despliegue de recursos, por ejemplo la region y el profile principal que usuarremos en el proveedor.
# Ej

locals {
  region  = var.region != "" ? var.region : "eu-west-1"
  profile = var.profile != "" ? var.profile : "default"



  #######NAMING#######
  cloud       = var.cloud
  project     = var.project
  env         = var.env
  service     = var.service
  naming_base = join("_", [local.project, local.env, local.service])

  cognito_domain = join("-", [local.project, local.env, "domain"])
  attributes     = {}
}
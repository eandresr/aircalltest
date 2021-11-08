resource "random_string" "suffix" {
  length    = 6
  min_lower = 6
  special   = false
}


resource "aws_codecommit_repository" "code_repo" {
  repository_name = local.repo_name
  description     = "This is the repo for the ${local.env} environmnet of the ${local.project} project"
}

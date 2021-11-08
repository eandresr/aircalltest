resource "random_string" "suffix" {
  length    = 6
  min_lower = 6
  special   = false
}


####### CODEBUILD ########
data "template_file" "buildspec_local" {
  template = file("./files/buildspec.yaml")
  vars = {
    Function = data.terraform_remote_state.lambda[0].outputs.arn
  }
}
resource "aws_codebuild_project" "default" {
  name           = local.codebuild_name
  service_role   = aws_iam_role.iam_for_codebuild_tf.arn
  build_timeout  = var.build_timeout
  source_version = var.source_version != "" ? var.source_version : null

  artifacts {
    type     = "S3"
    location = data.terraform_remote_state.s3bucket[0].outputs.id
  }

  cache {
    type     = lookup(local.cache, "type", null)
    location = lookup(local.cache, "location", null)
    modes    = lookup(local.cache, "modes", null)
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = "LINUX_CONTAINER" #var.build_type
    privileged_mode = var.privileged_mode
  }

  source {
    buildspec = data.template_file.buildspec_local.rendered
    type      = var.source_type
    location  = var.source_location != "" ? var.source_location : data.terraform_remote_state.codecommit[0].outputs.clone_url_http
  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.cloudwatch_group_name
      stream_name = "log-stream"
    }
  }
}

############ MONITORING ###########
resource "aws_cloudwatch_log_group" "codebuild_log_group" {
  name              = local.cloudwatch_group_name
  retention_in_days = 7
}
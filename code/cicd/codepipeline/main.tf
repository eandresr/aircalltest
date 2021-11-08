resource "random_string" "suffix" {
  length    = 6
  min_lower = 6
  special   = false
}


resource "aws_codepipeline" "codepipeline" {
  name     = local.pipeline_name
  role_arn = aws_iam_role.iam_for_codepipeline_tf.arn

  artifact_store {
    location = data.terraform_remote_state.s3bucket[0].outputs.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        RepositoryName = data.terraform_remote_state.codecommit[0].outputs.id
        BranchName     = data.terraform_remote_state.codecommit[0].outputs.default_branch
      }
    }
  }
  stage {
    name = "Approval"

    action {
      name             = "Approval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      input_artifacts  = []
      output_artifacts = []
      version          = "1"
      configuration = {
        NotificationArn = aws_sns_topic.user_approval.arn
        CustomData      = "${local.pipeline_name} needs your approval to continue deploying"
      }
    }
  }
  stage {
    name = "Build_and_Deploy"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["packaged"]
      version          = "1"

      configuration = {
        ProjectName = data.terraform_remote_state.codebuild[0].outputs.name
      }
    }
  }
}
resource "aws_sns_topic" "user_approval" {
  name = local.topic_name
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  count     = length(local.emails)
  topic_arn = aws_sns_topic.user_approval.arn
  protocol  = "email"
  endpoint  = local.emails[count.index]
}
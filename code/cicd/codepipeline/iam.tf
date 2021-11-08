##### PERMISSIONS #####

resource "aws_iam_role" "iam_for_codepipeline_tf" {
  name = format("%s-role", format("%s-role", local.pipeline_name))

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "apigw"
    }
  ]
}
EOF
}

data "template_file" "codepipeline_iam_policy" {
  template = file("./files/codepipeline_iam_policy.json.tpl")
  vars = {
    ArtifactS3 = data.terraform_remote_state.s3bucket[0].outputs.arn
    Region-Id  = data.aws_region.current.name
    Account-Id = data.aws_caller_identity.current.account_id
    Codecommit = data.terraform_remote_state.codecommit[0].outputs.arn
    SNS        = aws_sns_topic.user_approval.arn
  }
}
resource "aws_iam_policy" "codepipeline_iam_policy" {
  name        = format("%s-policy", format("%s-role", local.pipeline_name))
  path        = "/"
  description = "codepipeline policy"
  policy      = data.template_file.codepipeline_iam_policy.rendered
}
resource "aws_iam_role_policy_attachment" "codepipeline_iam_policy_attach" {
  role       = aws_iam_role.iam_for_codepipeline_tf.name
  policy_arn = aws_iam_policy.codepipeline_iam_policy.arn
  lifecycle {
    ignore_changes = [
      policy_arn
    ]
  }
}
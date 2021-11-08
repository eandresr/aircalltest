##### PERMISSIONS #####

resource "aws_iam_role" "iam_for_codebuild_tf" {
  name = format("%s-role", format("%s-role", local.codebuild_name))

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "apigw"
    }
  ]
}
EOF
}

data "template_file" "codebuild_iam_policy" {
  template = file("./files/codebuild_iam_policy.json.tpl")
  vars = {
    ArtifactS3     = data.terraform_remote_state.s3bucket[0].outputs.arn
    Region-Id      = data.aws_region.current.name
    Account-Id     = data.aws_caller_identity.current.account_id
    CodeBuild-Name = local.codebuild_name
    Function       = data.terraform_remote_state.lambda[0].outputs.arn
  }
}
resource "aws_iam_policy" "codebuild_iam_policy" {
  name        = format("%s-policy", format("%s-role", local.codebuild_name))
  path        = "/"
  description = "codebuild policy"
  policy      = data.template_file.codebuild_iam_policy.rendered
}
resource "aws_iam_role_policy_attachment" "codebuild_iam_policy_attach" {
  role       = aws_iam_role.iam_for_codebuild_tf.name
  policy_arn = aws_iam_policy.codebuild_iam_policy.arn
  lifecycle {
    ignore_changes = [
      policy_arn
    ]
  }
}
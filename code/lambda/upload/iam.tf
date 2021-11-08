##### PERMISSIONS #####

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${data.terraform_remote_state.apigw[0].outputs.id}/*/*/${data.terraform_remote_state.apigwcomp[0].outputs.path_main}"
}



resource "aws_iam_role" "iam_for_lambda_tf" {
  name = format("%s-role", format("%s-role", local.function_name))

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "apigw"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "apigateway"
    }
  ]
}
EOF
}

data "template_file" "lambda_iam_policy" {
  template = file("files/lambda_iam_policy.json.tpl")
  vars = {
    Region-Id  = data.aws_region.current.name
    Account-Id = data.aws_caller_identity.current.account_id
    BucketARN  = data.terraform_remote_state.s3bucket[0].outputs.arn
    Project    = var.project
    Lambda     = aws_lambda_function.main.function_name
  }
}
resource "aws_iam_policy" "lambda_iam_policy" {
  name        = format("%s-policy", format("%s-role", local.function_name))
  path        = "/"
  description = "Lambda policy"
  policy      = data.template_file.lambda_iam_policy.rendered
}
resource "aws_iam_role_policy_attachment" "lambda_iam_policy_attach" {
  role       = aws_iam_role.iam_for_lambda_tf.name
  policy_arn = aws_iam_policy.lambda_iam_policy.arn
  lifecycle {
    ignore_changes = [
      policy_arn
    ]
  }
}
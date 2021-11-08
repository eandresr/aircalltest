resource "random_string" "suffix" {
  length    = 6
  min_lower = 6
  special   = false
}


####### LAMBDA ########



resource "aws_lambda_function" "main" {
  filename      = "./files/lambda_handler.zip"
  function_name = local.function_name
  role          = aws_iam_role.iam_for_lambda_tf.arn
  handler       = var.handler
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("./files/lambda_handler.zip")
  runtime          = "nodejs14.x"
  timeout          = 300
  environment {
    variables = {
      S3_BUCKET = data.terraform_remote_state.s3bucket[0].outputs.id
    }
  }
}

############ MONITORING ###########
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.main.function_name}"
  retention_in_days = 7
}

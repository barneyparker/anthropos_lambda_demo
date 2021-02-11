data "archive_file" "event_lambda" {
  type        = "zip"
  output_path = "${path.module}/.terraform/event_lambda.zip"
  source_dir  = "./event_src"
}

resource "aws_iam_role" "event_lambda" {
  name               = "event_lambda_role"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          }
        }
      ]
    }
  EOF
}

resource "aws_lambda_function" "event_lambda" {
  function_name    = "${var.api_name}-event-lambda"
  filename         = data.archive_file.event_lambda.output_path
  source_code_hash = data.archive_file.event_lambda.output_base64sha256

  runtime = "nodejs12.x"
  handler = "index.handler"

  role = aws_iam_role.event_lambda.arn
}

resource "aws_lambda_permission" "event_lambda_permission" {
  statement_id  = "APIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.event_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.api.id}/*/*"
}

resource "aws_cloudwatch_log_group" "event_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.event_lambda.function_name}"
  retention_in_days = 7
}

resource "aws_iam_role_policy" "event_lambda_logging" {
  name   = "Cloudwatch-Logs"
  role   = aws_iam_role.event_lambda.name
  policy = <<-EOF
    {
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:logs:*:*:*"
        }
      ]
    }
  EOF
}


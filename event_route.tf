resource "aws_apigatewayv2_integration" "event_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  connection_type      = "INTERNET"
  description          = "event Route Handler"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.event_lambda.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "event_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /event"
  target    = "integrations/${aws_apigatewayv2_integration.event_integration.id}"
}
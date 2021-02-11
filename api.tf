resource "aws_apigatewayv2_api" "api" {
  name          = "${var.api_name}-${var.envname}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = false
    allow_headers     = ["*"]
    allow_methods     = ["*"]
    allow_origins     = ["*"]
    expose_headers    = ["*"]
    max_age           = 3600
  }
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "${var.api_name}-${var.envname}-stage"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode(
      {
        httpMethod     = "$context.httpMethod"
        ip             = "$context.identity.sourceIp"
        protocol       = "$context.protocol"
        requestId      = "$context.requestId"
        requestTime    = "$context.requestTime"
        responseLength = "$context.responseLength"
        routeKey       = "$context.routeKey"
        status         = "$context.status"
        message        = "$context.integrationErrorMessage"
      }
    )
  }

  lifecycle {
    ignore_changes = [
      deployment_id,
      default_route_settings
    ]
  }
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/api/${aws_apigatewayv2_api.api.name}"
  retention_in_days = 7
}

resource "aws_apigatewayv2_domain_name" "domain" {
  domain_name = "${var.api_name}.${data.aws_route53_zone.zone.name}"

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.cert.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "domain_mapping" {
  api_id      = aws_apigatewayv2_api.api.id
  domain_name = aws_apigatewayv2_domain_name.domain.id
  stage       = aws_apigatewayv2_stage.stage.id
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.api_name
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}

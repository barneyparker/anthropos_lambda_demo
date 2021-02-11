data "aws_acm_certificate" "cert" {
  domain   = "*.sandbox.anthropos.io"
  statuses = ["ISSUED"]
}
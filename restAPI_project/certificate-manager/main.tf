variable "domain_name" {}
variable "hosted_zone_id" {}

output "certificate_validation" {
  value = aws_acm_certificate_validation.cert_validation.certificate_arn
}

resource "aws_acm_certificate" "api_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}


resource "aws_route53_record" "cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.api_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  
  ttl = 60

  zone_id         = var.hosted_zone_id
}



resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.api_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]
}
variable "hz_name" {}
variable "aws_lb_dns_name" {}
variable "aws_lb_zone_id" {}

output "dev_proj-1_hz_id" {
  value = data.aws_route53_zone.dev_proj_1_hz.id
}

data "aws_route53_zone" "dev_proj_1_hz" {
  name         = var.hz_name
  private_zone = false
}

resource "aws_route53_record" "site_principal_alias" {
  zone_id = data.aws_route53_zone.dev_proj_1_hz.zone_id
  
  name    = "felipeprojects.dev"
  type    = "A"

  alias {
    name                   = var.aws_lb_dns_name
    zone_id                = var.aws_lb_zone_id
    evaluate_target_health = true
  }
}
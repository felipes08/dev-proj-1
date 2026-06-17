variable "lb_name" {}
variable "lb_target_group_python_arn" {}
variable "cert_validation" {}

output "lb_dns_name" {
  value = data.aws_lb.alb_principal.dns_name
}

output "lb_dns_zone_id" {
  value = data.aws_lb.alb_principal.zone_id
}


data "aws_lb" "alb_principal" {
  name = var.lb_name
}

data "aws_lb_listener" "https_listener" {
  load_balancer_arn = data.aws_lb.alb_principal.arn
  port = 443
}


resource "aws_lb_listener_rule" "python_rule" {
  listener_arn = data.aws_lb_listener.https_listener.arn
  priority     = 20 

  action {
    type             = "forward"
    target_group_arn = var.lb_target_group_python_arn
  }

  condition {
    host_header {
      values = ["felipeprojects.dev", "www.felipeprojects.dev"]
    }
  }
}

resource "aws_lb_listener_certificate" "python_cert_attachment" {
  listener_arn    = data.aws_lb_listener.https_listener.arn
  certificate_arn = var.cert_validation
}
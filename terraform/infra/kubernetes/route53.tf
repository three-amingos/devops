
# create SSL certificate
resource "aws_acm_certificate" "domain_cert" {
  domain_name               = var.dns_base_domain
  subject_alternative_names = ["*.${var.dns_base_domain}"]
  validation_method         = "DNS"
  tags = var.tags
}

resource "aws_route53_zone" "hosted_zone" {
  name = "${var.stack_name}.${var.dns_base_domain}"
  tags = var.tags
}

resource "aws_route53_record" "nameserver" {
  zone_id = data.aws_route53_zone.base_domain.id
  name    =  "${var.stack_name}.${var.dns_base_domain}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.hosted_zone.name_servers
}





//resource "aws_route53_record" "eks_domain" {
//  zone_id = data.aws_route53_zone.base_domain.id
//  name    = var.dns_base_domain
//  type    = "A"
//
//  alias {
//    name                   = data.kubernetes_service.ingress_gateway.load_balancer_ingress.0.hostname
//    zone_id                = data.aws_elb_hosted_zone_id.zone_id.id
//    evaluate_target_health = true
//  }
//  depends_on = [
//    aws_acm_certificate.domain_cert,
//    data.kubernetes_service.ingress_gateway
//  ]
//}

//resource "aws_route53_record" "domain_cert_validation_dns" {
//  name    = aws_acm_certificate.domain_cert.domain_validation_options.0.resource_record_name
//  type    = aws_acm_certificate.domain_cert.domain_validation_options.0.resource_record_type
//  zone_id = data.aws_route53_zone.base_domain.id
//  records = [aws_acm_certificate.domain_cert.domain_validation_options.0.resource_record_value]
//  ttl     = 60
//}
//
//
//resource "aws_acm_certificate_validation" "domain_cert_validation" {
//  certificate_arn         = aws_acm_certificate.domain_cert.arn
//  validation_record_fqdns = [aws_route53_record.domain_cert_validation_dns.fqdn]
//}
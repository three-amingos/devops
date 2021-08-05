
# deploy Ingress Controller
resource "helm_release" "ingress_gateway" {
  name       = var.ingress_name
  chart      = var.ingress_name
  repository = var.ingress_helm_repo
  namespace = var.ingress_name
  recreate_pods = true
//  version    = var.ingress_versions

  dynamic "set" {
    for_each = var.ingress_annotations
    content {
      name  = set.key
      value = set.value
      type  = "string"
    }
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = aws_acm_certificate.domain_cert.id
  }
}
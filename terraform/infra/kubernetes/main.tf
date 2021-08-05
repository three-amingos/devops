resource "random_string" "random" {
  length = 4
  special = false
  upper = false
}

locals {
  ssh_user = var.ssh_user
  cluster_name = "${var.stack_name}-${random_string.random.result}-${terraform.workspace}"
}


resource "kubectl_manifest" "external_dns" {
  yaml_body = templatefile("${path.module}/external-dns.yml", {external_dns_role_arn = aws_iam_role.external_dns_role.arn })
}



# get dns zone
data "aws_route53_zone" "base_domain" {
  name = var.dns_base_domain
}

data "aws_availability_zones" "available" {}
data "aws_elb_hosted_zone_id" "zone_id" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

# create base domain for EKS Cluster
data "kubernetes_service" "ingress_gateway" {
  metadata {
    name = join("-", [helm_release.ingress_gateway.chart, helm_release.ingress_gateway.name])
  }

  depends_on = [module.eks]
}
#define user data
data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false
  part {
    content = <<EOF
#cloud-config
---
cloud_final_modules:
- [users-groups,always]
users:
  - name: "${local.ssh_user}"
    gecos: "${local.ssh_user}"
    sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
    - "${tls_private_key.private_key.public_key_openssh}"
EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("ssm.sh")
  }
}

data "aws_iam_policy_document" "external_dns_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = ["arn:aws:route53:::hostedzone/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_dns_role_doc" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
    sid = ""
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.nodes_role.arn]
    }
  }
}

data "aws_iam_policy_document" "cluster_role_doc" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
    sid = ""
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "node_role_doc" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
    sid = ""
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "kubernetes_secret" "k8_auth_sa" {
  depends_on = [kubernetes_service_account.k8-auth]
  metadata {
    name = kubernetes_service_account.k8-auth.default_secret_name
    namespace = kubernetes_namespace.vault.metadata[0].name
  }
}

data "vault_policy_document" "reader_policy" {
  rule {
    path = "k8-demo/database/config"
    capabilities = ["read","list"]
    description = "allow reading secrets"
  }
}


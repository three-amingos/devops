
resource helm_release vault  {
  name       = "vault"
  namespace =  kubernetes_namespace.vault.metadata[0].name
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  recreate_pods = true
  version = "0.12.0"
  set {
    name  = "injector.enabled"
    value = "true"
  }
  set {
    name  = "injector.externalVaultAddr"
    value = var.vault_address
  }

}

resource "kubernetes_service_account" "k8-auth" {
  metadata {
    name = "vault-auth"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "vault_auth_role_binding" {
  metadata {
    name = "role-tokenreview-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "system:auth-delegator"
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.k8-auth.metadata[0].name
    namespace = kubernetes_namespace.vault.metadata[0].name
  }
}

resource "vault_policy" "vault_policy" {
  name = "reader"
  policy = data.vault_policy_document.reader_policy.hcl
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "config" {
  backend = vault_auth_backend.kubernetes.path
  kubernetes_host = data.aws_eks_cluster.cluster.endpoint
  kubernetes_ca_cert = data.kubernetes_secret.k8_auth_sa.data["ca.crt"]
  token_reviewer_jwt = data.kubernetes_secret.k8_auth_sa.data["token"]
  issuer = "api"
  disable_iss_validation = "true"
}

resource "vault_kubernetes_auth_backend_role" "role" {
  backend = vault_auth_backend.kubernetes.path
  role_name = "demo"
  bound_service_account_names = [
    kubernetes_service_account.k8-auth.metadata[0].name
  ]
  bound_service_account_namespaces = ["*"]
  token_ttl = 43200
  token_policies = [vault_policy.vault_policy.name]
}

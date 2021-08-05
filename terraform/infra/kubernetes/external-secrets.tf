resource helm_release external_secret  {
  name       = "external-secrets"
  repository = "https://external-secrets.github.io/kubernetes-external-secrets"
  chart      = "kubernetes-external-secrets"
  version = "8.2.3"
  namespace = kubernetes_namespace.vault.metadata[0].name
  set {
    name = "env.VAULT_ADDR"
    value = var.vault_address
  }
  set {
    name = "env.DEFAULT_VAULT_ROLE"
    value = "demo"
  }
  set {
    name = "env.DEFAULT_VAULT_MOUNT_POINT"
    value = "demo"
  }
 set {
   name = "env.VAULT_NAMESPACE"
    value = "admin"
  }
}

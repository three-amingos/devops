resource "kubernetes_service_account" "app" {
  metadata {
    name      = "vault-auth"
    namespace =  kubernetes_namespace.app.metadata[0].name
  }
  automount_service_account_token = true
}



resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name = "poc"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      name = "poc"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "poc"
      }
    }

    template {
      metadata {
        labels = {
          name = "poc"
        }
        annotations = {
          "vault.hashicorp.com/agent-inject": "true"
          "vault.hashicorp.com/agent-inject-secret-demo": "k8-demo/database/config"
          "vault.hashicorp.com/role": "demo"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.app.metadata[0].name
        container {
          image = "nginx:1.7.8"
          name  = "poc"
        }
      }
    }
  }
}
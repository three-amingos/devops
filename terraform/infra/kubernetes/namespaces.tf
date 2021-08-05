
resource "kubernetes_namespace" "ingress" {
  metadata {
    name = var.ingress_name
  }

}

resource "kubernetes_namespace" "vault" {
  metadata {
    name =  "vault"
  }

}

resource "kubernetes_namespace" "kes" {
  metadata {
    name = "kes"
  }

}

resource "kubernetes_namespace" "mongo_ns" {
  metadata {
    name = "mongo"
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "poc"
  }
}
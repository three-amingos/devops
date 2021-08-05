resource "kubernetes_service_account" "mongo_sa" {
  metadata {
    name      = "vault-auth"
    namespace =  kubernetes_namespace.mongo_ns.metadata[0].name
  }

  automount_service_account_token = true
}


resource "kubectl_manifest" "mongo_express" {
  yaml_body = <<YAML

---
apiVersion: "kubernetes-client.io/v1"
kind: ExternalSecret
metadata:
  name: mongodb-secret
spec:
  backendType: vault
  vaultMountPoint: kubernetes
  vaultRole: demo
  data:
    - name: mongodb_root_user
      key: k8-demo/database/config
      property: mongodb_root_user
    - name: mongodb_root_password
      key: k8-demo/database/config
      property: mongodb_root_password

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb
  labels:
    app: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo
        ports:
        - containerPort: 27017
        env:
          - name: MONGO_INITDB_ROOT_USERNAME
            valueFrom:
              secretKeyRef:
                name: mongodb-secret
                key: mongo_root_user
          - name: MONGO_INITDB_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mongodb-secret
                key: mongo_root_password


---
apiVersion: v1
kind: Service
metadata:
  name: mongo-service
spec:
  selector:
    app: mongodb
  ports:
    - protocol: TCP
      port: 27017
      targetPort: 27017



YAML
}


//resource "kubernetes_service" "mongo_express" {
//  metadata {
//    name = "mongo-express-service"
//    namespace = kubernetes_namespace.mongo_ns.id
//  }
//  spec {
//    selector = {
//      app = kubernetes_deployment.mongo_express.metadata.0.labels.name
//    }
//    port {
//      port        = 8081
//      target_port = 8081
//    }
//
//    type = "LoadBalancer"
//  }
//}



//resource "kubernetes_deployment" "mongo" {
//  metadata {
//    name = "mongo"
//    namespace = kubernetes_namespace.mongo_ns.metadata[0].name
//    labels = {
//      name = "mongo"
//    }
//  }
//
//  spec {
//    replicas = 1
//
//    selector {
//      match_labels = {
//        name = "mongo"
//      }
//    }
//
//    template {
//      metadata {
//        labels = {
//          name = "mongo"
//          namespace = kubernetes_namespace.mongo_ns.id
//        }
//        annotations = {
//          "vault.hashicorp.com/agent-inject": "true"
//          "vault.hashicorp.com/agent-inject-secret-demo": "k8-demo/database/config"
//          "vault.hashicorp.com/role": "demo"
//        }
//      }
//
//      spec {
//        service_account_name = kubernetes_service_account.mongo_sa.metadata[0].name
//        container {
//          image = "mongo"
//          name  = "mongo"
//          port {
//            container_port = 27017
//          }
//        }
//      }
//    }
//  }
//}

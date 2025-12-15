resource "kubernetes_namespace" "demo" {
  metadata {
    name = var.namespace
    labels = {
      environment = "demo"
    }
  }
}

resource "kubernetes_secret" "demo" {
  metadata {
    name      = "demo-secret"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  data = {
    demo_username = base64encode("demo-user")
    demo_password = base64encode("demo-pass")
  }

  type = "Opaque"
}

resource "kubernetes_deployment" "demo" {
  metadata {
    name      = "demo-api"
    namespace = kubernetes_namespace.demo.metadata[0].name
    labels = { app = "demo-api" }
  }
  spec {
    replicas = 2
    selector {
      match_labels = { app = "demo-api" }
    }
    template {
      metadata {
        labels = { app = "demo-api" }
      }
      spec {
        container {
          name  = "demo-api"
          image = "demo-api:local"
          port {
            container_port = 5000
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 2
            period_seconds        = 5
          }
        }
      }
    }
  }
}
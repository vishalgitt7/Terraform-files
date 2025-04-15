# Configure the Helm provider for Kubernetes
provider "helm" {
  kubernetes {
    config_path = var.kube_config_path # Assumes your kubeconfig is set up for the existing EKS cluster
  }
}

# Create the monitoring namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace_name
  }
}

# Install Prometheus stack using Helm
resource "helm_release" "prometheus_stack" {
  name       = "prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = var.helm_chart_version # Adjust to the latest stable version

  # Set the service type to NodePort
  set {
    name  = "prometheus.prometheusSpec.service.type"
    value = "NodePort"
  }

  # No explicit nodePort value set; Kubernetes assigns a random port
}

# Output the assigned NodePort
data "kubernetes_service" "prometheus_service" {
  metadata {
    name      = "prometheus-stack-kube-prom-prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  depends_on = [helm_release.prometheus_stack]
}

output "prometheus_nodeport" {
  value       = data.kubernetes_service.prometheus_service.spec[0].port[0].node_port
  description = "The assigned NodePort for Prometheus"
}
# Configure the Kubernetes provider
   provider "kubernetes" {
     config_path    = "~/.kube/config"
     config_context = "arn:aws:eks:us-west-2:<account-id>:cluster/<cluster-name>" # Replace with your cluster context
   }

   # Configure the Helm provider
   provider "helm" {
     kubernetes {
       config_path    = "~/.kube/config"
       config_context = "arn:aws:eks:us-west-2:<account-id>:cluster/<cluster-name>"
     }
   }

   # Create the argocd namespace
   resource "kubernetes_namespace" "argocd" {
     metadata {
       name = "argocd"
     }
   }

   # Deploy ArgoCD using the Helm chart
   resource "helm_release" "argocd" {
     name       = "argocd"
     repository = "https://argoproj.github.io/argo-helm"
     chart      = "argo-cd"
     namespace  = kubernetes_namespace.argocd.metadata[0].name
     version    = "7.6.7" # Specify a stable chart version

     # Configure NodePort service
     set {
       name  = "server.service.type"
       value = "NodePort"
     }
     set {
       name  = "server.service.nodePort"
       value = "30080" # Optional: Specify a port; omit for auto-assignment
     }
     set {
       name  = "server.insecure"
       value = "true" # For testing; disable in production
     }

     depends_on = [kubernetes_namespace.argocd]
   }

   # Output the NodePort
   data "kubernetes_service" "argocd_server" {
     metadata {
       name      = "argocd-server"
       namespace = kubernetes_namespace.argocd.metadata[0].name
     }
     depends_on = [helm_release.argocd]
   }

   output "argocd_node_port" {
     value       = data.kubernetes_service.argocd_server.spec[0].port[0].node_port
     description = "The NodePort assigned to the ArgoCD server"
   }

   output "argocd_cluster_ip" {
     value       = data.kubernetes_service.argocd_server.spec[0].cluster_ip
     description = "The ClusterIP of the ArgoCD server"
   }
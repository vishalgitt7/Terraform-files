# Configure the Kubernetes provider
   provider "kubernetes" {
     config_path    = "~/.kube/config"
     config_context = "arn:aws:eks:us-east-1:546151329042:cluster/my-cluster" # Replace with your cluster context
   }

   # Configure the Helm provider
   provider "helm" {
     kubernetes = {
       config_path    = "~/.kube/config"
       config_context = "arn:aws:eks:us-east-1:546151329042:cluster/my-cluster"
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
     set = [
     {
       name  = "server.service.type"
       value = "LoadBalancer"
     }
    ]

     depends_on = [kubernetes_namespace.argocd]
   }

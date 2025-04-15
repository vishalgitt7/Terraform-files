variable "namespace_name" {
  default = "monitoring"
}

variable "helm_chart_version" {
  default = "51.0.0" # Keep it updated as needed
}

variable "kube_config_path" {
  default = "~/.kube/config"
}
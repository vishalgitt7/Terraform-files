variable "region" {
  description = "The AWS region to deploy the EKS cluster"
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "my-cluster"
}

variable "security_group_name" {
  description = "The name of the security group"
  default     = "eks_security_group"
}

variable "cluster_role_name" {
  description = "The name of the IAM role for the EKS cluster"
  default     = "my-eks-cluster-role"
}

variable "node_role_name" {
  description = "The name of the IAM role for the EKS node group"
  default     = "my-eks-node-role"
}

variable "subnet_ids" {
 description = "List of subnet IDs for the EKS cluster"
 type = list(string)
 default = ["your subnetID-1", "your subnetID-2" ]
 }
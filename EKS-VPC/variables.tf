variable "region" {
  description = "AWS region to deploy resources"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "subnet_a_cidr" {
  description = "CIDR block for the first subnet"
}

variable "subnet_b_cidr" {
  description = "CIDR block for the second subnet"
}

variable "cluster_name" {
  description = "EKS cluster name"
}

variable "security_group_name" {
  description = "Security group name"
}

variable "cluster_role_name" {
  description = "IAM role name for the cluster"
}

variable "node_role_name" {
  description = "IAM role name for the node group"
}

variable "enable_public_ip" {
  description = "Enable auto-assign public IP for subnets"
  type        = bool
}
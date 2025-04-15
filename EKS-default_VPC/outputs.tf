output "cluster_name" {
  value = aws_eks_cluster.example.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.example.vpc_config[0].cluster_security_group_id
}

output "node_group_name" {
  value = aws_eks_node_group.example.node_group_name
}
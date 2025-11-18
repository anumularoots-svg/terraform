# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# Security Group Outputs
output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.security.eks_cluster_sg_id
}

output "jenkins_security_group_id" {
  description = "Jenkins security group ID"
  value       = module.security.jenkins_sg_id
}

# IAM Outputs
output "eks_cluster_role_arn" {
  description = "EKS cluster IAM role ARN"
  value       = module.iam.eks_cluster_role_arn
}

output "jenkins_instance_profile" {
  description = "Jenkins IAM instance profile name"
  value       = module.iam.jenkins_instance_profile_name
}

# ECR Outputs
output "ecr_repository_urls" {
  description = "ECR repository URLs"
  value       = module.ecr.repository_urls
}

# EKS Outputs
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_oidc_issuer" {
  description = "EKS cluster OIDC issuer"
  value       = module.eks.cluster_oidc_issuer_url
}

# Jenkins Outputs
output "jenkins_public_ip" {
  description = "Jenkins server public IP"
  value       = module.jenkins.public_ip
}

output "jenkins_url" {
  description = "Jenkins server URL"
  value       = "http://${module.jenkins.public_ip}:8080"
}

output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = module.jenkins.instance_id
}
# Project Configuration
project_name = "my-project"
environment  = "dev"
aws_region   = "us-east-1"

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]
enable_nat_gateway   = true

# ECR Repositories
ecr_repository_names = [
  "frontend",
  "backend",
  "api-service"
]

# EKS Configuration
eks_cluster_version      = "1.28"
eks_node_instance_types  = ["m7i-flex.large"]
eks_desired_capacity     = 2
eks_min_capacity         = 1
eks_max_capacity         = 4

# Jenkins Configuration
jenkins_instance_type = "m7i-flex.large"
key_name              = "devkey"  # Change to your key pair name
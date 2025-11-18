# VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  enable_nat_gateway   = var.enable_nat_gateway
}

# Security Groups Module
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = module.vpc.vpc_cidr
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  account_id   = data.aws_caller_identity.current.account_id
}

# ECR Module
module "ecr" {
  source = "./modules/ecr"

  project_name     = var.project_name
  environment      = var.environment
  repository_names = var.ecr_repository_names
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  project_name           = var.project_name
  environment            = var.environment
  cluster_version        = var.eks_cluster_version
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  public_subnet_ids      = module.vpc.public_subnet_ids
  cluster_security_group = module.security.eks_cluster_sg_id
  node_security_group    = module.security.eks_node_sg_id
  node_instance_types    = var.eks_node_instance_types
  desired_capacity       = var.eks_desired_capacity
  min_capacity           = var.eks_min_capacity
  max_capacity           = var.eks_max_capacity
}

# Jenkins EC2 Module
module "jenkins" {
  source = "./modules/jenkins"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.public_subnet_ids[0]
  security_group_id   = module.security.jenkins_sg_id
  instance_type       = var.jenkins_instance_type
  key_name            = var.key_name
  iam_instance_profile = module.iam.jenkins_instance_profile_name
}

# Data source for account ID
data "aws_caller_identity" "current" {}
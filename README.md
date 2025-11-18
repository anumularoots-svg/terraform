# terraform

📋 Table of Contents

Overview
Architecture
Prerequisites
Project Structure
Installation
Configuration
Deployment
Post-Deployment
Usage
Monitoring
Troubleshooting
Best Practices
Clean Up
Contributing


🎯 Overview
This Terraform project creates a complete AWS infrastructure with the following components:

VPC with public and private subnets across multiple availability zones
EKS (Elastic Kubernetes Service) cluster for container orchestration
ECR (Elastic Container Registry) for Docker image storage
Jenkins CI/CD server on EC2
IAM Roles and Policies for secure access management
Security Groups for network security
NAT Gateways for private subnet internet access

Key Features
✅ Highly available multi-AZ architecture
✅ Secure networking with public/private subnet separation
✅ Auto-scaling EKS node groups
✅ Automated CI/CD with Jenkins
✅ Container registry with lifecycle policies
✅ Infrastructure as Code with Terraform
✅ Modular and reusable code structure

🏗️ Architecture
┌─────────────────────────────────────────────────────────────┐
│                          AWS Cloud                           │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    VPC (10.0.0.0/16)                  │  │
│  │                                                        │  │
│  │  ┌──────────────────┐      ┌──────────────────┐      │  │
│  │  │  Public Subnet   │      │  Public Subnet   │      │  │
│  │  │   (AZ-1a)        │      │   (AZ-1b)        │      │  │
│  │  │                  │      │                  │      │  │
│  │  │  ┌────────────┐  │      │  ┌────────────┐  │      │  │
│  │  │  │  Jenkins   │  │      │  │ NAT Gateway│  │      │  │
│  │  │  │   EC2      │  │      │  │            │  │      │  │
│  │  │  └────────────┘  │      │  └────────────┘  │      │  │
│  │  └──────────────────┘      └──────────────────┘      │  │
│  │           │                         │                 │  │
│  │  ┌──────────────────┐      ┌──────────────────┐      │  │
│  │  │ Private Subnet   │      │ Private Subnet   │      │  │
│  │  │   (AZ-1a)        │      │   (AZ-1b)        │      │  │
│  │  │                  │      │                  │      │  │
│  │  │  ┌────────────┐  │      │  ┌────────────┐  │      │  │
│  │  │  │ EKS Nodes  │  │      │  │ EKS Nodes  │  │      │  │
│  │  │  │            │  │      │  │            │  │      │  │
│  │  │  └────────────┘  │      │  └────────────┘  │      │  │
│  │  └──────────────────┘      └──────────────────┘      │  │
│  │                                                        │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐  │
│  │      ECR       │  │      EKS      │  │      IAM      │  │
│  │  Repositories  │  │    Cluster    │  │   Roles       │  │
│  └───────────────┘  └───────────────┘  └───────────────┘  │
└─────────────────────────────────────────────────────────────┘

📦 Prerequisites
Required Software
SoftwareVersionDownload LinkTerraform>= 1.0DownloadAWS CLI>= 2.0Downloadkubectl>= 1.28DownloadDocker>= 20.10DownloadGitLatestDownload
AWS Requirements

AWS Account with appropriate permissions
AWS Access Keys (Access Key ID & Secret Access Key)
EC2 Key Pair for SSH access
IAM Permissions for creating:

VPC and networking resources
EC2 instances
EKS clusters
ECR repositories
IAM roles and policies



Minimum IAM Permissions
json{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "eks:*",
        "ecr:*",
        "iam:*",
        "s3:*",
        "dynamodb:*"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## 📁 Project Structure
```
terraform/
├── main.tf                      # Main configuration file
├── providers.tf                 # Provider configurations
├── variables.tf                 # Root module variables
├── outputs.tf                   # Root module outputs
├── terraform.tfvars            # Variable values (customize this)
├── backend.tf                   # Remote state configuration
├── README.md                    # This file
│
├── modules/
│   ├── vpc/                     # VPC module
│   │   ├── main.tf             # VPC resources
│   │   ├── variables.tf        # VPC variables
│   │   └── outputs.tf          # VPC outputs
│   │
│   ├── security/                # Security Groups module
│   │   ├── main.tf             # Security group resources
│   │   ├── variables.tf        # Security variables
│   │   └── outputs.tf          # Security outputs
│   │
│   ├── iam/                     # IAM module
│   │   ├── main.tf             # IAM roles and policies
│   │   ├── variables.tf        # IAM variables
│   │   └── outputs.tf          # IAM outputs
│   │
│   ├── ecr/                     # ECR module
│   │   ├── main.tf             # ECR repositories
│   │   ├── variables.tf        # ECR variables
│   │   └── outputs.tf          # ECR outputs
│   │
│   ├── eks/                     # EKS module
│   │   ├── main.tf             # EKS cluster and node groups
│   │   ├── variables.tf        # EKS variables
│   │   └── outputs.tf          # EKS outputs
│   │
│   └── jenkins/                 # Jenkins module
│       ├── main.tf             # Jenkins EC2 instance
│       ├── variables.tf        # Jenkins variables
│       └── outputs.tf          # Jenkins outputs

🚀 Installation
Step 1: Clone the Repository
bashgit clone <your-repo-url>
cd terraform
Step 2: Configure AWS Credentials
Option 1: Using AWS CLI
bashaws configure
Option 2: Using Environment Variables
bashexport AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
Option 3: Using AWS Profile
bashexport AWS_PROFILE="your-profile-name"
Step 3: Create EC2 Key Pair
bash# Create a new key pair
aws ec2 create-key-pair \
  --key-name my-keypair \
  --query 'KeyMaterial' \
  --output text > my-keypair.pem

# Set permissions
chmod 400 my-keypair.pem
Step 4: Initialize Backend (Optional)
If using remote state with S3:
bash# Create S3 bucket for state
aws s3 mb s3://my-terraform-state-bucket --region us-east-1

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
Update backend.tf with your bucket name.

⚙️ Configuration
Edit terraform.tfvars
hcl# Project Configuration
project_name = "my-project"          # Your project name
environment  = "dev"                 # Environment: dev, staging, prod
aws_region   = "us-east-1"           # AWS region

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
eks_node_instance_types  = ["t3.medium"]
eks_desired_capacity     = 2
eks_min_capacity         = 1
eks_max_capacity         = 4

# Jenkins Configuration
jenkins_instance_type = "t3.medium"
key_name              = "my-keypair"  # Your EC2 key pair name
Cost Estimation
ResourceTypeEstimated Monthly CostEKS ClusterControl Plane$73EC2 Instances (t3.medium x2)EKS Nodes~$60NAT Gateway (x2)Networking~$64Jenkins EC2 (t3.medium)CI/CD~$30ECRStorage~$1-5Total~$228-232/month

Note: Actual costs may vary based on usage, data transfer, and additional services.


🎬 Deployment
Step 1: Initialize Terraform
bashterraform init
```

**Expected Output:**
```
Initializing modules...
Initializing the backend...
Initializing provider plugins...

Terraform has been successfully initialized!
Step 2: Validate Configuration
bashterraform validate
```

**Expected Output:**
```
Success! The configuration is valid.
Step 3: Format Code
bashterraform fmt -recursive
Step 4: Plan Deployment
bashterraform plan -out=tfplan
Review the plan carefully. It should show:

Resources to be created
No resources to be destroyed (for new deployment)

Step 5: Apply Configuration
bashterraform apply tfplan
Or apply directly with confirmation:
bashterraform apply
Type yes when prompted.
Deployment Time: Approximately 15-20 minutes
Step 6: Verify Deployment
bash# Show all outputs
terraform output

# Get specific output
terraform output jenkins_url
terraform output eks_cluster_name

🔧 Post-Deployment
1. Configure kubectl for EKS
bash# Update kubeconfig
aws eks update-kubeconfig \
  --region us-east-1 \
  --name my-project-dev

# Verify connection
kubectl get nodes
kubectl get pods --all-namespaces
```

**Expected Output:**
```
NAME                                          STATUS   ROLES    AGE   VERSION
ip-10-0-11-xxx.ec2.internal                  Ready    <none>   5m    v1.28.x
ip-10-0-12-xxx.ec2.internal                  Ready    <none>   5m    v1.28.x
2. Access Jenkins
Get Jenkins URL
bashterraform output jenkins_url
SSH to Jenkins Server
bash# Get Jenkins public IP
JENKINS_IP=$(terraform output -raw jenkins_public_ip)

# SSH into Jenkins
ssh -i my-keypair.pem ec2-user@$JENKINS_IP
Get Initial Admin Password
bashsudo cat /var/lib/jenkins/secrets/initialAdminPassword
Access Jenkins Web UI

Open browser: http://<jenkins-ip>:8080
Enter initial admin password
Install suggested plugins
Create admin user
Configure Jenkins URL

3. Configure ECR Access
Login to ECR
bash# Get ECR login token
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  <account-id>.dkr.ecr.us-east-1.amazonaws.com
Get ECR Repository URLs
bashterraform output ecr_repository_urls
Push Image to ECR
bash# Tag image
docker tag my-app:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/my-project-dev-frontend:latest

# Push image
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/my-project-dev-frontend:latest
4. Configure Jenkins for EKS
Install Jenkins Plugins

Kubernetes Plugin
Docker Pipeline
AWS Steps
Git Plugin

Add AWS Credentials in Jenkins

Go to: Manage Jenkins → Manage Credentials
Add AWS credentials (IAM role is already attached)
Add kubeconfig for EKS access

Sample Jenkinsfile
groovypipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '<account-id>.dkr.ecr.us-east-1.amazonaws.com/my-project-dev-frontend'
        EKS_CLUSTER = 'my-project-dev'
    }
    
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t my-app .'
            }
        }
        
        stage('Push to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                    docker tag my-app:latest $ECR_REPO:${BUILD_NUMBER}
                    docker push $ECR_REPO:${BUILD_NUMBER}
                '''
            }
        }
        
        stage('Deploy to EKS') {
            steps {
                sh '''
                    aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER
                    kubectl set image deployment/my-app my-app=$ECR_REPO:${BUILD_NUMBER}
                '''
            }
        }
    }
}

💻 Usage
Working with EKS
Deploy Application
bash# Create deployment
kubectl create deployment nginx --image=nginx

# Expose deployment
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Get service URL
kubectl get svc nginx
Scale Application
bash# Scale deployment
kubectl scale deployment nginx --replicas=3

# Autoscale
kubectl autoscale deployment nginx --min=2 --max=10 --cpu-percent=80
View Logs
bash# Get pod logs
kubectl logs -f <pod-name>

# Get deployment logs
kubectl logs -f deployment/nginx
Working with ECR
List Repositories
bashaws ecr describe-repositories --region us-east-1
List Images in Repository
bashaws ecr describe-images \
  --repository-name my-project-dev-frontend \
  --region us-east-1
Delete Image
bashaws ecr batch-delete-image \
  --repository-name my-project-dev-frontend \
  --image-ids imageTag=v1.0.0 \
  --region us-east-1
Terraform Operations
View State
bashterraform show
List Resources
bashterraform state list
Import Existing Resource
bashterraform import module.vpc.aws_vpc.main vpc-xxxxx
Refresh State
bashterraform refresh
Target Specific Module
bash# Plan only VPC module
terraform plan -target=module.vpc

# Apply only Jenkins module
terraform apply -target=module.jenkins

📊 Monitoring
CloudWatch Logs
View EKS Logs
bash# List log groups
aws logs describe-log-groups --region us-east-1

# Tail logs
aws logs tail /aws/eks/my-project-dev/cluster --follow
View Jenkins Logs
bashssh -i my-keypair.pem ec2-user@<jenkins-ip>
sudo tail -f /var/log/jenkins/jenkins.log
EKS Cluster Metrics
bash# Get cluster info
kubectl cluster-info

# Get node metrics (requires metrics-server)
kubectl top nodes

# Get pod metrics
kubectl top pods --all-namespaces
Cost Monitoring
bash# Get cost and usage
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics "BlendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE

🔍 Troubleshooting
Common Issues
Issue 1: EKS Nodes Not Joining Cluster
Solution:
bash# Check node group status
aws eks describe-nodegroup \
  --cluster-name my-project-dev \
  --nodegroup-name my-project-dev-node-group

# Check IAM role
aws iam get-role --role-name my-project-dev-eks-node-role

# Check security groups
kubectl get nodes
kubectl describe node <node-name>
Issue 2: Jenkins Not Accessible
Solution:
bash# Check instance status
aws ec2 describe-instances --instance-ids <instance-id>

# Check security group rules
aws ec2 describe-security-groups --group-ids <sg-id>

# SSH and check Jenkins service
ssh -i my-keypair.pem ec2-user@<jenkins-ip>
sudo systemctl status jenkins
Issue 3: Terraform State Lock
Solution:
bash# Force unlock (use with caution)
terraform force-unlock <lock-id>

# Check DynamoDB table
aws dynamodb scan --table-name terraform-state-lock
Issue 4: ECR Authentication Failed
Solution:
bash# Get new login token
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Check IAM permissions
aws iam get-user
aws sts get-caller-identity
Debug Commands
bash# Terraform debug mode
export TF_LOG=DEBUG
terraform apply

# Kubernetes debug
kubectl get events --all-namespaces --sort-by='.lastTimestamp'
kubectl describe pod <pod-name>

# AWS CLI debug
aws eks list-clusters --debug

✅ Best Practices
Security

Never commit sensitive data

bash   # Add to .gitignore
   *.tfvars
   *.tfstate
   *.tfstate.backup
   .terraform/
   *.pem

Use remote state with encryption
Enable MFA for AWS account
Rotate access keys regularly
Use least privilege IAM policies
Enable CloudTrail for auditing

Cost Optimization

Use spot instances for non-production

hcl   capacity_type = "SPOT"

Enable auto-scaling
Delete unused resources
Use S3 lifecycle policies for ECR
Monitor costs with AWS Budgets

Terraform

Use workspaces for environments

bash   terraform workspace new dev
   terraform workspace new staging
   terraform workspace new prod

Version lock providers
Use modules for reusability
Run terraform fmt before committing
Use terraform validate in CI/CD


🧹 Clean Up
Destroy Infrastructure
bash# Plan destroy
terraform plan -destroy

# Destroy all resources
terraform destroy

# Destroy specific module
terraform destroy -target=module.jenkins
Manual Cleanup (if needed)
bash# Delete EKS cluster
aws eks delete-cluster --name my-project-dev

# Delete ECR repositories
aws ecr delete-repository \
  --repository-name my-project-dev-frontend \
  --force

# Delete S3 state bucket
aws s3 rb s3://my-terraform-state-bucket --force

# Delete DynamoDB table
aws dynamodb delete-table --table-name terraform-state-lock
Verify Cleanup
bash# Check running EC2 instances
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"

# Check VPCs
aws ec2 describe-vpcs

# Check EKS clusters
aws eks list-clusters

📚 Additional Resources
Documentation

Terraform AWS Provider
AWS EKS Documentation
Kubernetes Documentation
Jenkins Documentation

Tutorials

Terraform AWS Tutorial
EKS Workshop
Jenkins Pipeline Tutorial

Tools

k9s - Kubernetes CLI manager
Lens - Kubernetes IDE
Terraform Docs - Generate documentation
tflint - Terraform linter


🤝 Contributing

Fork the repository
Create a feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request


📄 License
This project is licensed under the MIT License.

👥 Support
For issues and questions:

Create an issue in GitHub
Email: support@yourcompany.com
Slack: #terraform-support


🎉 Acknowledgments

HashiCorp for Terraform
AWS for cloud infrastructure
Kubernetes community
Jenkins community

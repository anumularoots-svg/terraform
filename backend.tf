terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state-25"  # Change this
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    
    # Optional: Use AWS profile
    # profile = "default"
  }
}

# Create S3 bucket for state (run this separately first)
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "my-terraform-state-bucket"
#   
#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_s3_bucket_versioning" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id
#   
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id
#   
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-state-lock"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#   
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

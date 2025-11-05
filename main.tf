# Find a recent Amazon Linux 2 (Kernel 5.x) AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*x86_64-gp2"]
  }
}

# Random suffix to ensure the S3 bucket name is globally unique
resource "random_pet" "suffix" {
  length = 2
}

# S3 bucket (private by default)
resource "aws_s3_bucket" "this" {
  bucket        = "${var.project}-${random_pet.suffix.id}"
  force_destroy = true

  tags = {
    Project = var.project
    Managed = "spacelift"
  }
}

# Keep public access blocked on the bucket
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Security group to allow SSH (22) and HTTP (80) from your IP (or 0.0.0.0/0 for demo)
# For a quick demo, this allows 0.0.0.0/0. Tighten for real use.
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project
    Managed = "spacelift"
  }
}

# Use the default VPC and a default subnet (simple demo)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Simple EC2 instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Optional SSH key
  key_name = var.ec2_key_name != "" ? var.ec2_key_name : null

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "Hello from Spacelift on $(hostname)" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF

  tags = {
    Name    = "${var.project}-web"
    Project = var.project
    Managed = "spacelift"
  }

  # Keep demo costs low—stop protection off, no EBS optimization changes, etc.
}

# Simple object to show the bucket works
resource "aws_s3_object" "example" {
  bucket  = aws_s3_bucket.this.id
  key     = "hello.txt"
  content = "Hello from Spacelift!"
}

output "bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "S3 bucket name"
}

output "ec2_instance_id" {
  value       = aws_instance.web.id
  description = "EC2 instance ID"
}

output "ec2_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the EC2 instance"
}

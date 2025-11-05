variable "project" {
  description = "Project/name prefix for resources"
  type        = string
  default     = "spacelift-demo"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "Optional EC2 key pair name (must already exist in the region). Leave empty to create without SSH key."
  type        = string
  default     = ""
}

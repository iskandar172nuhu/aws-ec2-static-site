variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Tag used to identify resources created by this project"
  type        = string
  default     = "ec2-static-site"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_allowed_cidr" {
  description = "Your public IP in CIDR form, e.g. 1.2.3.4/32 (SSH allowed only from here)"
  type        = string
}

variable "public_key_path" {
  description = "Path to your SSH public key (e.g., ~/.ssh/id_ed25519.pub)"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}


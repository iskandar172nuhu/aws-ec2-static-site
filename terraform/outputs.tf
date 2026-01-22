output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "website_url" {
  description = "URL of the deployed website"
  value       = "http://${aws_instance.web.public_ip}"
}

output "health_url" {
  description = "Health endpoint URL"
  value       = "http://${aws_instance.web.public_ip}/health"
}


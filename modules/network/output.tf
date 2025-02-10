output "vpc_id" {
  value = aws_vpc.${var.vpc_name}.id
}

output "subnet_id" {
  value       = aws_lb.main1.dns_name
}

output "application1_private_ip" {
  value = aws_instance.application1.private_ip
}
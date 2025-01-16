output "bastion1_public_ip" {
  value = aws_instance.bastion1.public_ip
}

output "load_balancer_dns" {
  value       = aws_lb.main1.dns_name
}

output "application1_private_ip" {
  value = aws_instance.application1.private_ip
}
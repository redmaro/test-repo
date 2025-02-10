output "vpc_id" {
  description = "ID du VPC"
  value       = aws_vpc.main.id
}

output "subnet_public1_id" {
  description = "ID du premier subnet public"
  value       = aws_subnet.public1.id
}

output "subnet_public2_id" {
  description = "ID du deuxième subnet public"
  value       = aws_subnet.public2.id
}

output "subnet_private1_id" {
  description = "ID du subnet privé"
  value       = module.network.subnet_private1_id
}

output "internet_gateway_id" {
  description = "ID de l'Internet Gateway"
  value       = aws_internet_gateway.igw1.id
}

output "nat_gateway_id" {
  description = "ID du NAT Gateway"
  value       = aws_nat_gateway.nat1.id
}

output "elastic_ip" {
  description = "ID de l'Elastic IP associée au NAT Gateway"
  value       = aws_eip.nat1.id
}

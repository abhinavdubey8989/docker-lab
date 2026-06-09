############################################
# Kafka Nodes
############################################

output "kafka_instance_ids" {
  description = "EC2 instance IDs of Kafka brokers"
  value       = aws_instance.kafka_nodes[*].id
}

output "kafka_public_ips" {
  description = "Public IP addresses of Kafka brokers"
  value       = aws_instance.kafka_nodes[*].public_ip
}

output "kafka_private_ips" {
  description = "Private IP addresses of Kafka brokers"
  value       = aws_instance.kafka_nodes[*].private_ip
}


############################################
# Application Nodes
############################################

output "app_instance_ids" {
  description = "EC2 instance IDs of Spring Boot application servers"
  value       = aws_instance.app_nodes[*].id
}

output "app_public_ips" {
  description = "Public IP addresses of Spring Boot application servers"
  value       = aws_instance.app_nodes[*].public_ip
}

output "app_private_ips" {
  description = "Private IP addresses of Spring Boot application servers"
  value       = aws_instance.app_nodes[*].private_ip
}
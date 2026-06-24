############################################
# Kafka EC2 Nodes
############################################

resource "aws_instance" "kafka_nodes" {
  count = var.kafka_instance_count

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  # aws_instance itself does not have a vpc_id argument
  # The VPC is inferred from the subnet-id specified
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [
    var.security_group_id
  ]

  associate_public_ip_address = true

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    encrypted             = false
    delete_on_termination = true
  }

  tags = {
    Name = "kafka-${count.index + 1}"
    Role = "kafka"
  }
}


############################################
# Spring Boot EC2 Nodes
############################################

resource "aws_instance" "app_nodes" {
  count = var.app_instance_count

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [
    var.security_group_id
  ]

  associate_public_ip_address = true

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    encrypted             = false
    delete_on_termination = true
  }

  tags = {
    Name = "app-${count.index + 1}"
    Role = "springboot"
  }
}
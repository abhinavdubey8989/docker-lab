variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "security_group_id" {
  description = "Existing Security Group ID, to be applied on the created EC2 machines"
  type        = string
  default     = "sg-00327297afc95f22b"
}

variable "ami_id" {
  description = "AMI ID to use for the instance, Ubuntu server 24.04"
  type        = string
  default     = "ami-0388e3ada3d9812da"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.xlarge"
}

variable "key_name" {
  description = "SSH key name for accessing the instance"
  type        = string
  default     = "ap-south-keypair-1"
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in"
  type        = string
  default     = "subnet-05f1339336f3e577c"
}

variable "kafka_instance_count" {
  description = "Number of EC2 instances to create for running kafka"
  type        = number
  default     = 2
}

variable "app_instance_count" {
  description = "Number of EC2 instances to create for running application"
  type        = number
  default     = 2
}

# variable "allowed_ssh_cidr" {
#   description = "CIDR block allowed to SSH into the EC2 instances"
#   type        = string
#   default     = "0.0.0.0/0"
# }

variable "root_volume_size" {
  description = "Root EBS volume size (in GB)"
  type        = number
  default     = 10
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "name" {
  description = "Base name for resources"
  type        = string
  default     = "sqops"
}

variable "kms_deletion_window_in_days" {
  description = "KMS key deletion window"
  type        = number
  default     = 7
}

variable "kms_key_rotation_enabled" {
  description = "Enable KMS key rotation"
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "General enable flag"
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "Enable multi-region KMS key"
  type        = bool
  default     = false
}

variable "kms_user" {
  description = "Optional KMS user ARNs"
  type        = list(string)
  default     = null
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vpc_availability_zones" {
  description = "List of AZs for the VPC"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "vpc_public_subnet_enabled" {
  description = "Enable public subnets"
  type        = bool
  default     = true
}

variable "vpc_private_subnet_enabled" {
  description = "Enable private subnets"
  type        = bool
  default     = true
}

variable "vpc_database_subnet_enabled" {
  description = "Enable database subnets"
  type        = bool
  default     = true
}

variable "vpc_intra_subnet_enabled" {
  description = "Enable intra subnets"
  type        = bool
  default     = true
}

variable "vpc_one_nat_gateway_per_az" {
  description = "One NAT gateway per AZ"
  type        = bool
  default     = false
}

variable "auto_assign_public_ip" {
  description = "Auto assign public IP"
  type        = bool
  default     = true
}

variable "vpc_flow_log_enabled" {
  description = "Enable VPC flow logs"
  type        = bool
  default     = false
}

variable "vpc_s3_endpoint_enabled" {
  description = "Enable VPC S3 endpoint"
  type        = bool
  default     = false
}

variable "vpc_ecr_endpoint_enabled" {
  description = "Enable VPC ECR endpoint"
  type        = bool
  default     = false
}

variable "vpn_server_enabled" {
  description = "Enable VPN server"
  type        = bool
  default     = false
}

variable "vpn_server_instance_type" {
  description = "EC2 instance type for VPN server"
  type        = string
  default     = "t3a.small"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.32"
}

variable "cluster_log_types" {
  description = "Types of logs to enable for EKS cluster"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_log_retention_in_days" {
  description = "Log retention days for EKS cluster logs"
  type        = number
  default     = 30
}

variable "managed_ng_capacity_type" {
  description = "Capacity type for managed node groups"
  type        = string
  default     = "SPOT"
}

variable "cluster_endpoint_public_access" {
  description = "Enable public endpoint access to EKS cluster"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDRs allowed to access the public endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_endpoint_private_access" {
  description = "Enable private endpoint access to EKS cluster"
  type        = bool
  default     = true
}

variable "ebs_volume_size" {
  description = "EBS volume size for nodes"
  type        = number
  default     = 50
}

variable "launch_template_name" {
  description = "Name for the launch template"
  type        = string
  default     = "launch-template-name"
}

variable "aws_managed_node_group_arch" {
  description = "Architecture for managed node group AMI"
  type        = string
  default     = "amd64"
}

variable "enable_bottlerocket_ami" {
  description = "Enable Bottlerocket AMI for node groups"
  type        = bool
  default     = false
}

variable "additional_aws_tags" {
  description = "Map of additional tags to apply to AWS resources"
  type        = map(string)
  default     = {
    Owner       = "Organization_name"
    Expires     = "Never"
    Department  = "Engineering"
    Product     = ""
    Environment = var.environment
  }
}

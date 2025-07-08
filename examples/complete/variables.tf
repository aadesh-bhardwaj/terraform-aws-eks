# Common
variable "environment" {
  description = "Environment identifier for the EKS cluster"
  default     = "dev"
  type        = string
}

variable "region" {
  description = "Region"
  default     = "us-east-2"
  type        = string
}

variable "name" {
  description = "Specify the name of the EKS cluster"
  default     = "test"
  type        = string
}

variable "aws_availability_zones" {
  type        = list(any)
  default     = ["us-east-2a", "us-east-2b"]
  description = "(optional) describe your variable"
}

# VPC
variable "external_id" {
  description = "External ID for the role arn"
  default     = "skaf-new-identifier"
  type        = string
}

variable "role_arn" {
  description = "Role ARN to deploy resources into another aws accounts"
  default     = "arn:aws:iam::118660115414:role/SKAFCAA-skaf-new-identifier"
  type        = string
}

variable "session_name" {
  description = "Name for the session to use role arn"
  default     = "test"
  type        = string
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Specify the CIDR range for VPC"
}

variable "enable_public_subnet" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "enable_private_subnet" {
  type        = bool
  description = "(optional) describe your variable"
  default     = true
}

variable "enable_intra_subnet" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "enable_database_subnet" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}
# variable "database_subnet_cidrs" {
#   description = "Database Tier subnet CIDRs to be created"
#   default     = []
#   type        = list(any)
# }

variable "ipv6_enabled" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
  default     = false
}

variable "vpn_server_enabled" {
  type        = bool
  default     = false
  description = "set it to true to deploy VPN server"
}

variable "vpn_key_pair_name" {
  description = "Specify the name of AWS Keypair to be used for VPN Server"
  default     = ""
  type        = string
}

variable "auto_assign_public_ip" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  type        = bool
  default     = false
}

variable "enable_flow_log" {
  type        = bool
  default     = false
  description = "Set it to true to enable flow log in VPC"
}

variable "create_one_nat_gateway_per_az" {
  type        = bool
  default     = false
  description = "Specify it to true to deploy one nat gateway in each az"
}

variable "vpn_server_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Specify the instance type you wanted to use for VPN"
}

variable "flow_log_max_aggregation_interval_in_seconds" {
  type        = number
  default     = 60
  description = "(optional) describe your variable"
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  type        = number
  default     = 90
  description = "(optional) describe your variable"
}

variable "flow_log_cloudwatch_log_group_kms_key_arn" {
  description = "The ARN of the KMS Key to use when encrypting log data for VPC flow logs"
  type        = string
  default     = null
}

variable "flow_log_cloudwatch_log_group_skip_destroy" {
  description = "Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state"
  type        = bool
  default     = false
}

variable "private_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on private subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = null
}

variable "public_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on public subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = null
}

variable "database_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on database subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = null
}

variable "intra_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on intra subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = null
}

# variable "ipv6_only" {
#   description = "Enable it for deploying native IPv6 network"
#   type        = bool
#   default     = false
# }

# variable "secondary_cidr_blocks" {
#   description = "List of the secondary CIDR blocks which can be at most 5"
#   type        = list(string)
#   default     = []
# }

# variable "secondry_cidr_enabled" {
#   description = "Whether enable secondary CIDR with VPC"
#   default     = false
#   type        = bool
# }

# variable "ipam_pool_id" {
#   description = "The existing IPAM pool id if any"
#   default     = null
#   type        = string
# }

# variable "ipam_enabled" {
#   description = "Whether enable IPAM managed VPC or not"
#   default     = false
#   type        = bool
# }

# variable "create_ipam_pool" {
#   description = "Whether create new IPAM pool"
#   default     = true
#   type        = bool
# }

# variable "ipv4_netmask_length" {
#   description = "The netmask length for IPAM managed VPC"
#   default     = 16
#   type        = number
# }

# variable "existing_ipam_managed_cidr" {
#   description = "The existing IPAM pool CIDR"
#   default     = ""
#   type        = string
# }

# variable "default_network_acl_ingress" {
#   description = "List of maps of ingress rules to set on the Default Network ACL"
#   type        = list(map(string))

#   default = [
#     {
#       rule_no    = 98
#       action     = "deny"
#       from_port  = 22
#       to_port    = 22
#       protocol   = "tcp"
#       cidr_block = "0.0.0.0/0"
#     },
#     {
#       rule_no    = 99
#       action     = "deny"
#       from_port  = 3389
#       to_port    = 3389
#       protocol   = "tcp"
#       cidr_block = "0.0.0.0/0"
#     },
#     {
#       rule_no    = 100
#       action     = "allow"
#       from_port  = 0
#       to_port    = 0
#       protocol   = "-1"
#       cidr_block = "0.0.0.0/0"
#     },
#     {
#       rule_no         = 101
#       action          = "allow"
#       from_port       = 0
#       to_port         = 0
#       protocol        = "-1"
#       ipv6_cidr_block = "::/0"
#     },
#   ]
# }

variable "vpc_s3_endpoint_enabled" {
  description = "Set to true if you want to enable vpc S3 endpoints"
  type        = bool
  default     = false
}

variable "vpc_ecr_endpoint_enabled" {
  description = "Set to true if you want to enable vpc ecr endpoints"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "KMS key to Encrypt EKS resources."
  default     = "arn:aws:kms:us-east-2:118660115414:key/86c3444d-9a3c-41c5-b6a9-83679a639e64"
  type        = string
}

variable "tags" {
  type = map(any)
  default = {
    "product" = "atmosly"
  }
  description = "(optional) describe your variable"
}

#EKS Module
variable "cluster_version" {
  description = "Kubernetes <major>.<minor> version to use for the EKS cluster"
  default     = "1.30"
  type        = string
}

variable "cluster_enabled_log_types" {
  type        = list(any)
  default     = []
  description = "(optional) describe your variable"
}

variable "cluster_log_retention_in_days" {
  type        = number
  default     = 30
  description = "(optional) describe your variable"
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  default     = true
  type        = bool
}

variable "cluster_endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled or not."
  default     = true
  type        = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created."
  type        = any
  default     = {}
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Indicates whether or not to add the cluster creator (the identity used by Terraform) as an administrator via access entry"
  type        = bool
  default     = true
}

variable "access_entry_enabled" {
  description = "Whether to enable access entry or not for eks cluster."
  type        = bool
  default     = true
}

variable "access_entries" {
  description = "Map of access entries to add to the cluster"
  type        = any
  default     = {}
}

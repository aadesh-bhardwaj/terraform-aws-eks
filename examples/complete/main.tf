locals {
  region      = var.region
  environment = var.environment
  additional_aws_tags = {
    Owner       = "Demo"
    Expires     = "Never"
    Department  = "Engineering"
    Product     = "Atmosly"
    Environment = local.environment
  }
}
#   kms_deletion_window_in_days          = 7
#   kms_key_rotation_enabled             = true
#   is_enabled                           = true
#   multi_region                         = false
#   name                                 = "sqops"
#   auto_assign_public_ip                = true
#   vpc_availability_zones               = ["us-east-2a", "us-east-2b"]
#   vpc_public_subnet_enabled            = true
#   vpc_private_subnet_enabled           = true
#   vpc_database_subnet_enabled          = true
#   vpc_intra_subnet_enabled             = true
#   vpc_one_nat_gateway_per_az           = false
#   vpn_server_instance_type             = "t3a.small"
#   vpc_flow_log_enabled                 = false
#   kms_user                             = null
#   vpc_cidr                             = "10.10.0.0/16"
#   vpn_server_enabled                   = false
#   cluster_version                      = "1.32"
#   cluster_log_types                    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
#   cluster_log_retention_in_days        = 30
#   managed_ng_capacity_type             = "SPOT" # Choose the capacity type ("SPOT" or "ON_DEMAND")
#   cluster_endpoint_private_access      = true
#   cluster_endpoint_public_access       = true
#   cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
#   ebs_volume_size                      = 50
#   fargate_profile_name                 = "app"
#   vpc_s3_endpoint_enabled              = false
#   vpc_ecr_endpoint_enabled             = false
#   vpc_public_subnets_counts            = 2
#   vpc_private_subnets_counts           = 2
#   vpc_database_subnets_counts          = 2
#   vpc_intra_subnets_counts             = 2
#   launch_template_name                 = "launch-template-name"
#   aws_managed_node_group_arch = "amd64" #Enter your linux arch (Example:- arm64 or amd64)
#   current_identity            = data.aws_caller_identity.current.arn
#   enable_bottlerocket_ami     = false

data "aws_caller_identity" "current" {}

module "kms" {
  source                  = "terraform-aws-modules/kms/aws"
  version                 = "3.1.0"
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = "Symmetric Key to Enable Encryption at rest using KMS services."
  enable_key_rotation     = var.kms_key_rotation_enabled
  is_enabled              = var.is_enabled
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = var.multi_region

  enable_default_policy                  = true
  key_owners                             = [data.aws_caller_identity.current.arn]
  key_administrators                     = var.kms_user == null ? ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS", data.aws_caller_identity.current.arn] : var.kms_user
  key_users                              = var.kms_user == null ? ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS", data.aws_caller_identity.current.arn] : var.kms_user
  key_service_users                      = var.kms_user == null ? ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS", data.aws_caller_identity.current.arn] : var.kms_user
  key_symmetric_encryption_users         = [data.aws_caller_identity.current.arn]
  key_hmac_users                         = [data.aws_caller_identity.current.arn]
  key_asymmetric_public_encryption_users = [data.aws_caller_identity.current.arn]
  key_asymmetric_sign_verify_users       = [data.aws_caller_identity.current.arn]

  key_statements = [
    {
      sid    = "AllowCloudWatchLogsEncryption"
      effect = "Allow"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]
      principals = [
        {
          type        = "Service"
          identifiers = ["logs.${var.region}.amazonaws.com"]
        }
      ]
    }
  ]

  aliases                 = ["${var.name}-KMS"]
  aliases_use_name_prefix = true
}

# module "key_pair_vpn" {
#   source             = "squareops/keypair/aws"
#   version            = "1.0.2"
#   count              = var.vpn_server_enabled ? 1 : 0
#   key_name           = format("%s-%s-vpn", var.environment, var.name)
#   environment        = var.environment
#   ssm_parameter_path = format("%s-%s-vpn", var.environment, var.name)
# }

# module "key_pair_eks" {
#   source             = "squareops/keypair/aws"
#   version            = "1.0.2"
#   key_name           = format("%s-%s-eks", var.environment, var.name)
#   environment        = var.environment
#   ssm_parameter_path = format("%s-%s-eks", var.environment, var.name)
# }

module "vpc" {
  source             = "squareops/vpc/aws"
  version            = "3.4.1"
  name               = var.name
  region             = var.region
  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  vpn_server_enabled = var.vpn_server_enabled
  # vpn_server_instance_type                        = var.vpn_server_instance_type
  # vpn_key_pair_name                               = var.vpn_server_enabled ? null : null
  availability_zones                              = var.vpc_availability_zones
  intra_subnet_enabled                            = var.vpc_intra_subnet_enabled
  public_subnet_enabled                           = var.vpc_public_subnet_enabled
  auto_assign_public_ip                           = var.auto_assign_public_ip
  private_subnet_enabled                          = var.vpc_private_subnet_enabled
  one_nat_gateway_per_az                          = var.vpc_one_nat_gateway_per_az
  database_subnet_enabled                         = var.vpc_database_subnet_enabled
  vpc_s3_endpoint_enabled                         = var.vpc_s3_endpoint_enabled
  vpc_ecr_endpoint_enabled                        = var.vpc_ecr_endpoint_enabled
  flow_log_enabled                                = var.vpc_flow_log_enabled
  flow_log_max_aggregation_interval               = 60
  flow_log_cloudwatch_log_group_skip_destroy      = false
  flow_log_cloudwatch_log_group_retention_in_days = 90
  flow_log_cloudwatch_log_group_kms_key_arn       = module.kms.key_arn
}

module "eks" {
  source                                   = "squareops/eks/aws"
  version                                  = "5.4.4"
  access_entry_enabled                     = false
  access_entries                           = {}
  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"
  name                                     = var.name
  vpc_id                                   = module.vpc.vpc_id
  environment                              = var.environment
  kms_key_arn                              = module.kms.key_arn
  cluster_version                          = var.cluster_version
  cluster_log_types                        = var.cluster_log_types
  vpc_private_subnet_ids                   = module.vpc.private_subnets
  cluster_log_retention_in_days            = var.cluster_log_retention_in_days
  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  cluster_endpoint_private_access          = var.cluster_endpoint_private_access
  cluster_security_group_additional_rules = {
    ingress_port_mgmt_tcp = {
      description = "demo vpc CIDR"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [var.vpc_cidr]
    }
  }
  enable_vpc_cni_addon = true
  vpc_cni_version      = "v1.19.3-eksbuild.1"
  tags                 = var.additional_aws_tags
}

module "managed_node_group_addons" {
  source                      = "squareops/eks/aws//modules/managed-nodegroup"
  version                     = "5.4.4"
  depends_on                  = [module.eks]
  managed_ng_name             = "Infra"
  managed_ng_min_size         = 2
  managed_ng_max_size         = 5
  managed_ng_desired_size     = 2
  vpc_subnet_ids              = [module.vpc.private_subnets[0]]
  environment                 = var.environment
  managed_ng_kms_key_arn      = module.kms.key_arn
  managed_ng_capacity_type    = var.managed_ng_capacity_type
  managed_ng_ebs_volume_size  = var.ebs_volume_size
  managed_ng_ebs_volume_type  = "gp3"
  managed_ng_ebs_encrypted    = true
  managed_ng_instance_types   = ["t3a.large", "t3.large", "t3.medium"]
  managed_ng_kms_policy_arn   = module.eks.kms_policy_arn
  associate_public_ip_address = false
  enable_coredns_addon        = true
  managed_ng_node_autorepair = {
    enabled                            = false
    enable_node_monitoring_agent_addon = true
  }
  eks_cluster_name              = module.eks.cluster_name
  worker_iam_role_name          = module.eks.worker_iam_role_name
  worker_iam_role_arn           = module.eks.worker_iam_role_arn
  managed_ng_pod_capacity       = 90
  managed_ng_monitoring_enabled = true
  launch_template_name          = var.launch_template_name
  k8s_labels = {
    "Addons-Services" = "true"
  }
  tags                        = var.additional_aws_tags
  custom_ami_id               = ""
  aws_managed_node_group_arch = var.aws_managed_node_group_arch
  enable_bottlerocket_ami     = var.enable_bottlerocket_ami
  bottlerocket_node_config = {
    bottlerocket_eks_node_admin_container_enabled = false
    bottlerocket_eks_enable_control_container     = true
  }
}

locals {
  name                = var.name
  region              = var.region
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  additional_aws_tags = var.tags
}

module "vpc" {
  source      = "squareops/vpc/aws"
  version     = "3.4.1"
  name        = local.name
  region      = local.region
  vpc_cidr    = local.vpc_cidr
  environment = local.environment

  availability_zones      = var.aws_availability_zones
  public_subnet_enabled   = var.enable_public_subnet   # ? [for k, v in var.aws_availability_zones : cidrsubnet(local.vpc_cidr, 8, k + 4)] : []
  private_subnet_enabled  = var.enable_private_subnet  # ? [for k, v in var.aws_availability_zones : cidrsubnet(local.vpc_cidr, 8, k)] : []
  database_subnet_enabled = var.enable_database_subnet # ? [for k, v in var.aws_availability_zones : cidrsubnet(local.vpc_cidr, 8, k + 8)] : []
  intra_subnet_enabled    = var.enable_intra_subnet    # ? [for k, v in var.aws_availability_zones : cidrsubnet(local.vpc_cidr, 8, k + 20)] : []

  one_nat_gateway_per_az                          = var.create_one_nat_gateway_per_az
  vpn_server_enabled                              = var.vpn_server_enabled
  vpn_server_instance_type                        = var.vpn_server_instance_type
  vpn_key_pair_name                               = var.vpn_key_pair_name
  kms_key_arn                                     = var.vpn_server_enabled ? var.kms_key_arn : ""
  auto_assign_public_ip                           = var.auto_assign_public_ip
  flow_log_enabled                                = var.enable_flow_log
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval_in_seconds
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_cloudwatch_log_group_skip_destroy      = var.flow_log_cloudwatch_log_group_skip_destroy
  flow_log_cloudwatch_log_group_kms_key_arn       = var.flow_log_cloudwatch_log_group_kms_key_arn
  vpc_s3_endpoint_enabled                         = var.vpc_s3_endpoint_enabled
  vpc_ecr_endpoint_enabled                        = var.vpc_ecr_endpoint_enabled
  ipv6_enabled                                    = var.ipv6_enabled
  public_subnet_assign_ipv6_address_on_creation   = var.public_subnet_assign_ipv6_address_on_creation
  private_subnet_assign_ipv6_address_on_creation  = var.private_subnet_assign_ipv6_address_on_creation
  database_subnet_assign_ipv6_address_on_creation = var.database_subnet_assign_ipv6_address_on_creation
  intra_subnet_assign_ipv6_address_on_creation    = var.intra_subnet_assign_ipv6_address_on_creation
}

module "eks" {
  depends_on                               = [module.vpc]
  source                                   = "squareops/eks/aws"
  version                                  = "5.2.0"
  name                                     = local.name
  vpc_id                                   = module.vpc.vpc_id
  vpc_private_subnet_ids                   = module.vpc.private_subnets
  environment                              = local.environment
  kms_key_arn                              = var.kms_key_arn
  cluster_version                          = var.cluster_version
  cluster_log_types                        = var.cluster_enabled_log_types
  cluster_log_retention_in_days            = var.cluster_log_retention_in_days
  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  cluster_endpoint_private_access          = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  cluster_security_group_additional_rules  = var.additional_rules
  ipv6_enabled                             = var.ipv6_enabled
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions
  access_entry_enabled                     = var.access_entry_enabled
  access_entries                           = var.access_entries
  authentication_mode                      = "API_AND_CONFIG_MAP"
}

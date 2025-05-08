variable "environment" {
  description = "Environment identifier for the EKS cluster, such as dev, qa, prod, etc."
  default     = "beta"
  type        = string
}

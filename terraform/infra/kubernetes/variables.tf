variable "tags" {
  description = "tags to associate with this instance"
  type = map(string)
}
variable "stack_name" {
  description = "name of the project"
  type = string
}
variable "region" {
  description = "aws region to deploy"
  type = string
}
variable "profile" {
  description = "iam user profile to use"
  type = string
}
variable "remote_state_bucket_name" {
  description = "name of the terraform remote state bucket"
  type = string
}
variable "instance_type" {
  description = "ec2 instance type for nodes"
  type = string
}
variable "vpc_cidr_block" {
  description = "CIDR Block for this  VPC. Example 10.0.0.0/16"
  default = "10.10.0.0/16"
  type = string
}
variable "public_subnets" {
  description = "Provide list of public subnets to use in this VPC. Example 10.0.1.0/24,10.0.2.0/24"
  default     = []
  type = list(string)
}
variable "private_subnets" {
  description = "Provide list private subnets to use in this VPC. Example 10.0.10.0/24,10.0.11.0/24"
  default     = []
  type = list(string)
}
variable "availability_zones" {
  description = "list of availability zones to use"
  type = list(string)
  default = []
}

variable "ssh_key_name" {
  description = "specify ssh key name"
  type = string
}
variable "ssh_user" {
  description = "name of ssh user"
  type = string
  default = "cloud"
}

# create some variables
variable "dns_base_domain" {
  type        = string
  description = "DNS Zone name to be used from EKS Ingress."
}
variable "ingress_name" {
  type        = string
  description = "Ingress Gateway Helm chart name."
}

variable "ingress_helm_repo" {
  type        = string
  description = "Ingress Gateway Helm repository name."
}

variable "ingress_annotations" {
  type        = map(string)
  description = "Ingress Gateway Annotations required for EKS."
}

variable "ingress_versions" {
  type = string
  description = "ingress controller version"
}
//variable "namespaces" {
//  type        = list(string)
//  description = "List of namespaces to be created in our EKS Cluster."
//}
variable "vault_address" {
  type = string
  description = "url of external vault"
}
variable "vault_namespace" {
  type = string
  default = "admin"
  description = "name of the vault namespace to use"
}

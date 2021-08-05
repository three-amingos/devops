#define any tags appropriate to your environment
tags = {
  Owner = "cloud-automation"
  MaintainedBy = "CloudProfessionals"
  Project = "Portfolio"
}

#specify vpc cidr
vpc_cidr_block = "10.220.0.0/16"

#define private subnet to use
private_subnets = ["10.220.48.0/20","10.220.64.0/20","10.220.80.0/20"]

#define public subnets to use. Note you must specify at least two subnets
public_subnets = ["10.220.0.0/20","10.220.16.0/20","10.220.32.0/20"]

#enter the region in which your aws resources will be provisioned
region = "us-east-1"

#specify your aws credential profile. Note this is not IAM role but rather profile configured during AWS CLI installation
profile = "cloud"

#specify the name you will like to call this project.
stack_name = "cloud"

ssh_key_name = "cloud"

remote_state_bucket_name = "portfolio-dev-1brk-tfstate-bucket"

instance_type = "t3.small"
#specify availability zones to provision your resources. Note the availability zone must match the number of public subnets. Also availability zones depends on the region.
#If you change the region use the corresponding availability zones
//availability_zones = ["us-east-1a","us-east-1b","us-east-1c"]
ingress_versions = "0.48.1"
dns_base_domain  = "tresamingo.com"
ingress_name    = "ingress-nginx"
ingress_helm_repo    = "https://kubernetes.github.io/ingress-nginx"
ingress_annotations = {
  "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"        = "tcp",
  "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout" = "60",
  "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"   = "true",
  "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"                    = "nlb"
}
vault_address = "https://k9-vault.vault.3ad1b035-3998-4461-bb01-d4da1ce16c5c.aws.hashicorp.cloud:8200"
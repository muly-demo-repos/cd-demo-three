module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name                         = join("-", ["vpc", local.environment])
  cidr                         = local.vpc_cidr_block
  azs                          = local.vpc_azs
  private_subnets              = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr_block, 8, k)]
  public_subnets               = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr_block, 8, k + 4)]
  database_subnets             = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr_block, 8, k + 8)]
  create_database_subnet_group = true
  enable_dns_hostnames         = true
  enable_dns_support           = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
}

module "sg_paz" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.0.0"

  name   = "rds-paz"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}
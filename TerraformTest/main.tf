module "remote_state" {
  source  = "nozaq/remote-state-s3-backend/aws"
  version = "1.5.0"

  terraform_iam_policy_create = false

  # Academy doesn't allow S3 replication
  enable_replication = false

  providers = {
    aws         = aws
    aws.replica = aws
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}

module "ec2" {
  source                = "./modules/ec2"
  vpc_id                = module.vpc.vpc_id
  instance_profile_name = module.iam.instance_profile_name
  public_subnet_ip      = module.vpc.public_subnet_id
  private_subnets_ids   = module.vpc.private_subnets_ids
  elb_security_group_id = module.elb.elb_security_group_id
}

module "elb" {
  source              = "./modules/elb"
  vpc_id              = module.vpc.vpc_id
  instance_id         = module.ec2.ec2_id
  private_subnets_ids = module.vpc.private_subnets_ids
}

#module "nat_gateway" {
#  source           = "./modules/vpc/nat_gateway"
#  public_subnet_id = module.vpc.public_subnet_id
#  vpc_id           = module.vpc.vpc_id
#  private_subnets_ids = module.vpc.private_subnets_ids
#}

module "cognito" {
  source = "./modules/cognito"
}
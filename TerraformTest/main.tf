module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source                = "./modules/ec2"
  vpc_id                = module.vpc.vpc_id
  instance_profile_name = "LabInstanceProfile"
  public_subnet_ip      = module.vpc.public_subnet_id
  private_subnets_ids   = module.vpc.private_subnets_ids
  elb_security_group_id = module.elb.elb_security_group_id
}

module "elb" {
  source              = "./modules/elb"
  vpc_id              = module.vpc.vpc_id
  private_subnets_ids = module.vpc.private_subnets_ids
}

module "nat_gateway" {
 source           = "./modules/nat_gateway"
 public_subnet_id = module.vpc.public_subnet_id
 vpc_id           = module.vpc.vpc_id
 private_subnets_ids = module.vpc.private_subnets_ids
 
}

module "cognito" {
  source = "./modules/cognito"
}

module "dydb" {
  source = "./modules/dydb"
}

module "launch_template" {
  source = "./modules/launch_template"
  users_sg_id = module.ec2.users_sg_id
  votes_sg_id = module.ec2.votes_sg_id
  instance_profile_name = "LabInstanceProfile"
}

module "asg" {
  source = "./modules/asg"
  private_subnets_ids = module.vpc.private_subnets_ids
  users_launch_template_id = module.launch_template.users_launch_template_id
  votes_launch_template_id = module.launch_template.votes_launch_template_id
  users_tg_arn = module.elb.users_tg_arn
  votes_tg_arn = module.elb.votes_tg_arn
}

module "api_gateway" {
  source = "./modules/api_gateway"
  nlb_arn = module.elb.nlb_arn
  nlb_dns = module.elb.dns_name
  user_pool_arn = module.cognito.pool_arn
}

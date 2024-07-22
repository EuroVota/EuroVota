module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source                = "./modules/ec2"
  vpc_id                = module.vpc.vpc_id
  # instance_profile_name = module.iam.instance_profile_name
  instance_profile_name = "LabInstanceProfile"
  public_subnet_ip      = module.vpc.public_subnet_id
  private_subnets_ids   = module.vpc.private_subnets_ids
  elb_security_group_id = module.elb.elb_security_group_id
}

module "elb" {
  source              = "./modules/elb"
  vpc_id              = module.vpc.vpc_id
  # instance_id         = module.ec2.ec2_id
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

# module "ami" {
#   source = "./modules/ami"
#   ec2_id = module.ec2.ec2_id
# }

module "launch_template" {
  source = "./modules/launch_template"
  # ami_id = module.ami.ami_id
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
  users_nlb_arn = module.elb.users_nlb_arn
  users_nlb_dns = module.elb.users_dns_name
  user_pool_arn = module.cognito.pool_arn
  votes_nlb_arn = module.elb.votes_nlb_arn
  votes_nlb_dns = module.elb.votes_dns_name
}

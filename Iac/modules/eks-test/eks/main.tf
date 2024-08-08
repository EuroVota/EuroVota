data "aws_key_pair" "lab" {
  key_name           = "vockey"
  include_public_key = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  #  version = "20.2.1"
  version = "19.1.0"

  cluster_name    = "lab-eks"
  cluster_version = "1.30"

  # IAM

  create_iam_role = false
  iam_role_arn    = var.role_arn
  enable_irsa     = false
  #enable_cluster_creator_admin_permissions = true

  # Encryption

  # Networking

  cluster_endpoint_public_access = true

  vpc_id = var.vpc_id

  subnet_ids = var.public_subnets_ids

  control_plane_subnet_ids = var.private_subnets_ids

  # Addons

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium", "t3.large"]
  }

  eks_managed_node_groups = {
    lab = {
      min_size     = 3
      max_size     = 6
      desired_size = 3

      instance_types = ["t3.large"]

      ec2_ssh_key = data.aws_key_pair.lab.key_name

      create_iam_role = false
      iam_role_arn    = var.role_arn
    }
  }

  tags = {
    Environment = "lab"
    Terraform   = "true"
  }
}
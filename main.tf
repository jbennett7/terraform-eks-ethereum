variable "role_arn" {
  type = string
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "deploy_ethereum" {
  type    = bool
  default = false
}

variable "map_users" {
  type = list(object({
    userarn = string
    username = string
    groups = list(string)
  }))
  default = []

# default = [
#   {
#     userarn  = "arn:aws:iam::66666666666:user/user1"
#     username = "user1"
#     groups   = ["system:masters"]
#   },
#   {
#     userarn  = "arn:aws:iam::66666666666:user/user2"
#     username = "user2"
#     groups   = ["system:masters"]
#   },
# ]
}

terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  assume_role {
    role_arn     = var.role_arn
    session_name = "ethereum"
  }
  region = var.region
}

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

data "aws_eks_cluster" "cluster" {
  name = module.ethereum_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.ethereum_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

module "ethereum_cluster" {
  source            = "github.com/jbennett7/terraform-eks.git"
  instance_type     = "c5n.large"
  asg_size          = 4
  name_prefix       = "Ethereum"
  map_users         = var.map_users
  update_kubeconfig = true
}

resource "null_resource" "deploy_ethereum" {
  count = var.deploy_ethereum ? 1 : 0
  provisioner "local-exec" {
    command = "for i in $(ls ethereum/);do kubectl apply -f ethereum/$i;done"
  }
  depends_on = [
    module.ethereum_cluster
  ]
}

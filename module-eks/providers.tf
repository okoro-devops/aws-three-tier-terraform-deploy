/*
Module `module-eks` provider guidance

Best practice:
- Do not pin provider versions inside modules. Pin versions in the root module's
  `required_providers` block.
- Configure provider blocks at the root and pass aliased providers into modules
  when needed (for example `provider = kubernetes.eks` in resources/data
  inside the module).

Example (place in the root where you call this module):

# data "aws_eks_cluster" "eks" {
#   name = var.cluster_name
# }
#
# data "aws_eks_cluster_auth" "eks" {
#   name = var.cluster_name
# }
#
# provider "kubernetes" {
#   alias                   = "eks"
#   host                    = data.aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate  = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks.name]
#   }
# }
#
# provider "helm" {
#   alias = "eks"
#   kubernetes {
#     host                   = data.aws_eks_cluster.eks.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "aws"
#       args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks.name]
#     }
#   }
# }

When you call the module, pass provider aliases if the module expects them. Example:

# module "eks_deployment" {
#   source = "./module-eks"
#   # ...module inputs...
#   providers = {
#     kubernetes = kubernetes.eks
#     helm       = helm.eks
#   }
# }

*/

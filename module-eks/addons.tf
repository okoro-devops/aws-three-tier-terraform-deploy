# provider "helm" {
#   kubernetes = {
#         host                   = aws_eks_cluster.eks.endpoint
#         cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
#         token                  = data.aws_eks_cluster_auth.eks.token
#     }
# }

# provider "kubernetes" {
#   alias                  = "eks"
#   host                   = aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks.token.value
# }

# data "aws_eks_cluster_auth" "eks" {
#     name = aws_eks_cluster.eks.name
# }
# resource "helm_release" "nginx_ingress" {
#     name       = "nginx-ingress"
#     repository = "https://kubernetes.github.io/ingress-nginx"
#     chart      = "ingress-nginx"
#     version    = "4.12.0"
#     namespace  = "ingress-nginx"
#     create_namespace = true

#     values = [file("${path.module}/nginx-ingress-values.yaml")]
#     depends_on = [ aws_eks_node_group.eks_node_group ]
# }

# data "aws_lb" "nginx_ingress" {
#   tags = {
#     "kubernetes.io/service-name" = "ingress-nginx/nginx-ingress-ingress-nginx-controller"
#   }

#   depends_on = [helm_release.nginx_ingress]
# }


#  resource "helm_release" "cert_manager" {
#      name       = "cert-manager"
#      repository = "https://charts.jetstack.io"
#      chart      = "cert-manager"
#      version    = "1.14.5"
#      namespace  = "cert-manager"
#      create_namespace = true
#      set = [
#       {
#        name  = "installCRDs"
#        value = "true"
#       }
#      ]
#      depends_on = [ 
#        helm_release.nginx_ingress 
#      ]
#  }
# #==================================================

# resource "helm_release" "argocd" {
#     name             = "argocd"
#     repository       = "https://argoproj.github.io/argo-helm"
#     chart            = "argo-cd"
#     version          = "9.1.3" #updated
#     namespace        = "argocd"
#     create_namespace = true
#     values = [file("${path.module}/argocd-values.yaml")]
#     depends_on = [ helm_release.nginx_ingress, helm_release.cert_manager]
# }

# ==========================
# Data: EKS Auth
# ==========================
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

# ==========================
# Providers
# ==========================
provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token

    }


# ==========================
# Helm: NGINX Ingress
# ==========================
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.12.0"
  namespace        = "ingress-nginx"
  create_namespace = true
  timeout          = 1200
  values           = [file("${path.module}/nginx-ingress-values.yaml")]

  depends_on = [
    aws_eks_node_group.eks_node_group
  ]
}

# NGINX LB Lookup
data "aws_lb" "nginx_ingress" {
  tags = {
    "kubernetes.io/service-name" = "ingress-nginx/nginx-ingress-ingress-nginx-controller"
  }
  depends_on = [helm_release.nginx_ingress]
}

# ==========================
# Helm: Cert-Manager
# ==========================
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.14.5"
  namespace        = "cert-manager"
  create_namespace = true

  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]

  depends_on = [helm_release.nginx_ingress]
}

# ==========================
# Helm: ArgoCD
# ==========================
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.6"
  namespace        = "argocd"
  create_namespace = true
  wait             = true                 # <-- IMPORTANT
  timeout          = 1200                 # <-- Give it time to start

  values = [
    file("${path.module}/argocd-values.yaml")
  ]

  depends_on = [
    helm_release.nginx_ingress,
    helm_release.cert_manager
  ]
}

# ==========================
# ArgoCD Load Balancer Lookup
# ==========================
#  data "aws_lb" "argocd" {
#   count = 1

#   tags = {
#     "kubernetes.io/service-name" = "argocd/argocd-server"
#   }

#   depends_on = [
#     helm_release.argocd
#   ]
# }

# =====================================
# Outputs
# =====================================

output "nginx_ingress_lb_dns" {
  value = try(data.aws_lb.nginx_ingress.dns_name, "")
}

#  output "argocd_lb_dns" {
#    value = try(data.aws_lb.argocd.dns_name, "")
#  }
# # output "argocd_lb_dns" {
  # value = try(data.aws_lb.argocd[0].dns_name, "")
# }





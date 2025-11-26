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



# provider "kubernetes" {
#   alias                  = "eks"
#   host                   = data.aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks.token
# }

# provider "helm" {
#   kubernetes = {
#     host                   = data.aws_eks_cluster.eks.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.eks.token
#   }
# }

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

data "aws_eks_cluster_auth" "eks" {
    name = aws_eks_cluster.eks.name
}
resource "helm_release" "nginx_ingress" {
    name       = "nginx-ingress"
    repository = "https://kubernetes.github.io/ingress-nginx"
    chart      = "ingress-nginx"
    version    = "4.12.0"
    namespace  = "ingress-nginx"
    create_namespace = true
    timeout = 600 # Increased timeout to 10 minutes

    values = [file("${path.module}/nginx-ingress-values.yaml")]
    depends_on = [ aws_eks_node_group.eks_node_group ]
}

data "aws_lb" "nginx_ingress" {
  tags = {
    "kubernetes.io/service-name" = "ingress-nginx/nginx-ingress-ingress-nginx-controller"
  }

  depends_on = [helm_release.nginx_ingress]
}

resource "helm_release" "cert_manager" {
    name       = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart      = "cert-manager"
    version    = "1.14.5"
    namespace  = "cert-manager"
    create_namespace = true
    set = [{
        name  = "installCRDs"
        value = "true"
    }]
    depends_on = [ helm_release.nginx_ingress ]
}
#==================================================

resource "helm_release" "argocd" {
    name             = "argocd"
    repository       = "https://argoproj.github.io/argo-helm"
    chart            = "argo-cd"
    version          = "5.51.6"
    namespace        = "argocd"
    create_namespace = true
    values = [file("${path.module}/argocd-values.yaml")]
    depends_on = [ helm_release.nginx_ingress, helm_release.cert_manager]
}

# =====================================
# AWS Load Balancer Lookups
# =====================================

# ArgoCD LB
data "aws_lb" "argocd" {
  tags = {
    "kubernetes.io/service-name" = "argocd/argocd-server"
  }

  depends_on = [
    helm_release.argocd
  ]
}
# =====================================
# Outputs
# =====================================

output "nginx_ingress_lb_dns" {
  value = try(data.aws_lb.nginx_ingress.dns_name, "")
}

output "argocd_lb_dns" {
  value = try(data.aws_lb.argocd.dns_name, "")
}





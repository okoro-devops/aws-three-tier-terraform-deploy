// Root provider and required_providers configuration.
//
// This file pins provider sources/versions at the root. Modules should
// not pin provider versions; instead modules should document provider
// expectations (see module-*/providers.tf).

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "aws" {
  region = "us-east-1"
}

# Kubernetes & Helm providers are configured in-module using exec auth
# so they use the EKS IAM auth token at runtime. See module-eks/providers.tf
# for example provider alias configuration.

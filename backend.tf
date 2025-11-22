terraform {
  backend "s3" {
    region = "eu-north-1"
    bucket = "pod-6-project"
    key    = "pod-6-project/terraform.tfstate"
  }
}
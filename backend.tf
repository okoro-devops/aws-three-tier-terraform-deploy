terraform {
  backend "s3" {
    bucket = "pod-6-project"
    key    = "pod-6-project/terraform.tfstate"
  }
}
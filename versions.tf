terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}
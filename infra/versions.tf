terraform {
  required_version = ">= 0.14.8"
  backend "gcs" {
    bucket = "kunal-scratch-dcentral-twitter-infra"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version     = ">= 4.36.0, < 5.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version     = ">= 4.36.0, < 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
    null = {
      source = "hashicorp/null"
      version = ">= 2.1"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 2.2"
    }
  }
}
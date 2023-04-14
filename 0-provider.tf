terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-1"
<<<<<<< HEAD
  access_key = "AKIAY2KYF7BFSCQ555PU"
  secret_key = "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"
=======
  access_key = 
  secret_key = 
>>>>>>> 71406892564596d628092aa1708dc660c53ceb2d
}

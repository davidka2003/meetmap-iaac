terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67"
    }
  }
}


provider "aws" {
  profile = "d4v1ds0n"
  region  = "eu-west-1"

}


module "vpc" {
  source     = "./vpc"
  app_prefix = local.app_prefix
}

module "budget" {
  source = "./budget"
}



# module "ecs"{
#     source = "./ecs"
# }
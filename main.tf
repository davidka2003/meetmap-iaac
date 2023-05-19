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
  source = "./vpc"
}

module "budget" {
  source = "./budget"
}

module "users" {
  source = "./users"
}


# module "ecs"{
#     source = "./ecs"
# }

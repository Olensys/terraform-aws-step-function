terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 6.0, < 7.0" }
  }
}

provider "aws" {
  region = "eu-west-1"
}

locals {
  context = {
    organization = "olensys"
    environment  = "test"
    application  = "sfn"
    owner        = "platform"
    cost_center  = "eng"
  }
}

module "naming" {
  source = "git::https://github.com/Olensys/terraform-null-naming.git?ref=v1.0.1"

  context = local.context
}

module "this" {
  source = "../../"

  name    = module.naming.name
  context = local.context
  tags    = module.naming.tags

  definition_json = jsonencode({
    StartAt = "Hello"
    States = {
      Hello = { Type = "Pass", Next = "Done" }
      Done  = { Type = "Pass", End = true }
    }
  })
}
